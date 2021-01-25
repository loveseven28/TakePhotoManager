//
//  LoginSocialManager.swift
//  TakePhotoManager
//
//  Created by HungSang on 1/20/21.
//  Copyright © 2021 DangHung. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

// MARK: - FacebookUser
struct FacebookUser: Codable {
    let firstName, id, lastName: String
    let pictureUrl: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case pictureUrl
    }
}

class LoginSocialManager: NSObject {
    let fireAuth : FirebaseAuthenticator = FirebaseAuthenticator()
    let socialAuth : SocialAuthenticator = SocialAuthenticator()
    var successLoginWithApple:((_ data: Any?,_ error: Error?) -> ())?
    var successLoginWithFacebook:((_ data: FacebookUser?,_ error: Error?) -> ())?
    var successLoginWithGoogle:((_ data: GIDGoogleUser?,_ error: Error?) -> ())?
    init(facebookButton: UIButton? = nil, googleButton: UIButton? = nil, appleButton: UIButton? = nil) {
        super.init()
        ///setup apple button
        if let appleButton = appleButton {
            appleButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        }
        ///setup facebook button
        if let facebookButton = facebookButton {
            facebookButton.addTarget(self, action: #selector(loginWithFacebookTapped), for: .touchUpInside)
        }
        
        ///Setup goole button
        if let googleButton = googleButton {
            GIDSignIn.sharedInstance().clientID = AppKey.GoogleKey.rawValue
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = UIWindow.topViewController()
            googleButton.addTarget(self, action: #selector(loginWithGoogleTapped), for: .touchUpInside)
        }
        fireAuth.delegate = self
        socialAuth.delegate = self
    }
    
    @objc func loginWithGoogleTapped() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func loginWithFacebookTapped() {
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            loginManager.logOut()
        } else {
            loginManager.logIn(permissions: [], from: UIWindow.topViewController()) { (result, error) in
                guard error == nil else {
                    // Error occurred
                    self.onFBErrorResponse(error : error)
                    print(error!.localizedDescription)
                    return
                }
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    self.onFBErrorResponse(error : error)
                    return
                }
                self.socialAuth.facebookLogin()
            }
        }
    }
    
    @objc
    private func handleAuthorizationAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            
        }
    }
}

extension LoginSocialManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    // MARK: - LOGIN APPLE
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIWindow.topViewController()!.view.window!
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
                    
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            self.successLoginWithApple?(appleIDCredential, nil)
            print(idTokenString, userIdentifier, fullName ?? "", email ?? "")
        }
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        guard let error = error as? ASAuthorizationError else {
            return
        }
        self.successLoginWithApple?(nil, error)
        switch error.code {
        case .canceled:
            print("Canceled")
        case .unknown:
            print("Unknown")
        case .invalidResponse:
            print("Invalid Respone")
        case .notHandled:
            print("Not handled")
        case .failed:
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
}

extension LoginSocialManager: SocialDelegate {
    //MARK: FACEBOOK LOGIN API -----
    func onFBSuccessResponse(user: Any) {
        if let userDataDict = user as? NSDictionary {
            let first_name = userDataDict["first_name"] as? String
            let id = userDataDict["id"] as? String
            let last_name = userDataDict["last_name"] as? String
            let pictDict =  userDataDict["picture"] as? NSDictionary
            let pictureUrl = pictDict?["data"] as? NSDictionary
            let picture = pictureUrl?["url"] as? String
            let user = FacebookUser(firstName: first_name ?? "",
                                    id: id ?? "",
                                    lastName: last_name ?? "",
                                    pictureUrl: picture ?? "")
            self.successLoginWithFacebook?(user, nil)
        }
    }
    
    func onFBErrorResponse(error: Error?) {
        self.successLoginWithFacebook?(nil, error)
    }
    
    func onGoogleSuccessResponse(user: Any) {
        
    }
    
    func onGoogleErrorResponse(error: Error?) {
        
    }
}

extension LoginSocialManager: ResponseDelegate {
    //MARK: FIREBASE LOGIN API -----
    
    func onApiResponse(user: AuthDataResult) {

    }
    
    func onErrorResponse(error: Error?) {

    }
}

extension LoginSocialManager: GIDSignInDelegate {
    //MARK: GOOGLE LOGIN API -----
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            print("User id is "+userId!+"")
            let idToken = user.authentication.idToken // Safe to send to the server
            print("Authentication idToken is "+idToken!+"")
            let fullName = user.profile.name
            print("User full name is "+fullName!+"")
            let givenName = user.profile.givenName
            print("User given profile name is "+givenName!+"")
            let familyName = user.profile.familyName
            print("User family name is "+familyName!+"")
            let email = user.profile.email
            print("User email address is "+email!+"")
            self.successLoginWithGoogle?(user, nil)
            if(user.profile.hasImage){
                URLSession.shared.dataTask(with: NSURL(string: user.profile.imageURL(withDimension: 400).absoluteString)! as URL, completionHandler: { (data, response, error) -> Void in
                    
                    if error != nil {
                        print(error ?? "No Error")
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                    })
                    
                }).resume()
            } else {
                
            }
            
        } else {
            print("ERROR ::\(error.localizedDescription)")
            self.successLoginWithGoogle?(nil, error)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

