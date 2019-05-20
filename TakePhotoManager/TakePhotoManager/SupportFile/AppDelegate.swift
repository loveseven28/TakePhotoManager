//
//  AppDelegate.swift
//  TakePhotoManager
//
//  Created by HoanVu on 5/8/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit
import UserNotifications
import Reachability
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBar()
//        self.registerForPushNotification(application: application)
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        Messaging.messaging().isAutoInitEnabled = true
        //handle notification
        if let launch = launchOptions , let userInfo = launch[UIApplication.LaunchOptionsKey.remoteNotification] {
            handleNotification(userInfo: userInfo as! [AnyHashable : Any], application: application)
        }
        return true
    }

    fileprivate func setupNavigationBar(){
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font : AppFont.Roboto.font(ofSize: 16, weight: .Bold),
                                                            NSAttributedString.Key.foregroundColor : UIColor.white] as [NSAttributedString.Key : Any]
        self.window?.backgroundColor = UIColor.white
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.startCheckNetwork()
    }

}

//MARK: REGISTER NOTIFICATION
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func registerForPushNotification(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail to register with error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        handleNotification(userInfo: userInfo, application: application)
    }
    
    func handleNotification(userInfo: [AnyHashable : Any], application: UIApplication) {
        if let dictionary = userInfo as? [String:Any] {
            print(dictionary.description)
        }
        
        guard let dict = userInfo as? [String:Any] else {
            return
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
//        let result: (NotiModel?, Error?) = NetworkManager.shared.decodableToObject(response: dict)
//        if let data = result.0 {
//            if let window = UIWindow.topViewController() {
//
//            }
//        } else {
//            print(result.1?.localizedDescription ?? "")
//        }
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        SettingsApp.deviceToken = fcmToken
        print("FCM TOKEN" ,fcmToken)
        
    }
    
}


// MARK: Check network
extension AppDelegate {
    func startCheckNetwork() {
        //declare this inside of viewWillAppear
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            postNotify(rechable: "connected")
        case .cellular:
            print("Reachable via Cellular")
            postNotify(rechable: "connected")
        case .none:
            print("Network not reachable")
            postNotify(rechable: "notConnection")
        }
    }
    
    func postNotify(rechable: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkChanged"), object: nil, userInfo: ["reachable":rechable])
    }
}
