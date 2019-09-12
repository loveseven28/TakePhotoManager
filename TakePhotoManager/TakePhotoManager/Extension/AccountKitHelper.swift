//
//  AccountKitHelper.swift
//  Cholimex
//
//  Created by HoanVu on 8/12/19.
//  Copyright © 2019 Cholimex. All rights reserved.
//

import UIKit
import AccountKit

protocol AccountKitHelperDelegate: class {
    func accountKitHelper(_ accountKitHelper: AccountKitHelper, didCompleteLoginWith phoneNumber: String)
}
class AccountKitHelper: NSObject, AKFViewControllerDelegate {
    var _accountKit: AccountKit?
    weak var delegate: AccountKitHelperDelegate?
    init(parentVC: UIViewController, phoneNumber: String) {
        super.init()
        if _accountKit == nil {
            _accountKit = AccountKit(responseType: .accessToken)
        }
        
        self.validateSMS(parentVC, phoneNumber: phoneNumber)
    }
    
    private func validateSMS(_ parentViewController: UIViewController, phoneNumber: String) {
        let initState = UUID().uuidString
        let phone = PhoneNumber(countryCode: "VN", phoneNumber: phoneNumber)
        guard let smsVC = _accountKit?.viewControllerForPhoneLogin(with: phone, state: initState) else { return }
        smsVC.isSendToFacebookEnabled = true
        smsVC.whitelistedCountryCodes = ["VN"]
        
        smsVC.uiManager = SkinManager(skinType: .translucent, primaryColor: AppColor.mainColor, backgroundImage: #imageLiteral(resourceName: "14.jpg"), backgroundTint: .white, tintIntensity: 0.65)
        prepare(smsVerify: smsVC)
        
        parentViewController.present(smsVC, animated: true, completion: nil)
    }
    
    private func prepare(smsVerify: AKFViewController) {
        smsVerify.delegate = self
    }
    
    func viewController(_ viewController: UIViewController & AKFViewController, didCompleteLoginWith accessToken: AccessToken, state: String) {
        guard let accountKit = _accountKit else { return }
        accountKit.requestAccount { account, error in
            if let phoneNumber = account?.phoneNumber {
                print(phoneNumber.phoneNumber)
                self.delegate?.accountKitHelper(self, didCompleteLoginWith: phoneNumber.phoneNumber)
            }
        }
    }
}
