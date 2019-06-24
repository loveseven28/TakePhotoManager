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
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        self.present(self.menuVC, animated: true, completion:   nil)
    }

    @IBAction func hashTagButtonTapped(_ sender: Any) {
        
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
