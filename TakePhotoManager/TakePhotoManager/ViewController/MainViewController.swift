//
//  MainViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 5/20/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: BaseViewController {
    var locationManager: CLLocationManager?
    @IBOutlet weak var tamOcButton: UIButton!
    @IBOutlet weak var tamOcConstraintTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMenuView()
        setGradientNavi()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.showsBackgroundLocationIndicator = false
        tamOcConstraintTop.constant = 50
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        addLabel()
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        self.present(self.menuVC, animated: true, completion:   nil)
    }

    @IBAction func hashTagButtonTapped(_ sender: Any) {
        
    }
    
    func addLabel() {
        let attrs: NSMutableAttributedString = NSMutableAttributedString()
        let ursName: NSAttributedString = NSAttributedString(string: "User Id ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.blue])
        let msg: NSAttributedString = NSAttributedString(string: "Message ", attributes: [NSAttributedString.Key.backgroundColor: UIColor.gray])
        let name: NSAttributedString = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        
        attrs.append(ursName)
        attrs.append(msg)
        attrs.append(name)
        
        let label: UILabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 20))
        label.attributedText = attrs
        
        label.center = view.center
        view.addSubview(label)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            // you're good to go!
            locationManager?.startUpdatingLocation()
            locationManager!.allowsBackgroundLocationUpdates = true
            locationManager!.pausesLocationUpdatesAutomatically = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
        }
    }
}
