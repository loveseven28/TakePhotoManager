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
    var accountKit: AccountKitHelper?
    override func viewDidLoad() {
        super.viewDidLoad()

        initMenuView()
        setGradientNavi()
        
        tamOcConstraintTop.constant = 50
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        addLabel()
        
        getAddresFromIPAddress { (result, erreo) in
            print(result!)
        }
    }
    
    private func validateSMS(phoneNumber: String) {
        accountKit = AccountKitHelper(parentVC: self, phoneNumber: phoneNumber)
        accountKit?.delegate = self
    }
    
    private func detectLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.showsBackgroundLocationIndicator = false
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        self.present(self.menuVC, animated: true, completion:   nil)
    }

    @IBAction func chatButtonTapped(_ sender: Any) {
        let chatVC = UIStoryboard.chatViewController()
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func accountKit(_ sender: UIButton) {
        self.validateSMS(phoneNumber: "0909921679")
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
    
    private func getAddresFromIPAddress(_ complete: @escaping ([String: Any]?, Error?) -> Void) {
        let urlString = "http://ip-api.com/json"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                        complete(json, nil)
                    }
                    
                } catch {
                    
                }
            }
            }.resume()
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
//            print("New location is \(location)")
        }
    }
}

extension MainViewController: AccountKitHelperDelegate {
    func accountKitHelper(_ accountKitHelper: AccountKitHelper, didCompleteLoginWith phoneNumber: String) {
        print("SDT: ", phoneNumber)
    }
}
