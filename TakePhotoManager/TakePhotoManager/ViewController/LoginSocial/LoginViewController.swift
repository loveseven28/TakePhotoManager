//
//  LoginViewController.swift
//  TakePhotoManager
//
//  Created by HungSang on 1/20/21.
//  Copyright © 2021 DangHung. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginApple: UIButton!
    @IBOutlet weak var loginGoogle: UIButton!
    @IBOutlet weak var loginFacebook: UIButton!
    @IBOutlet weak var critterView: CritterView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    private lazy var showHidePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        let height: CGFloat = passwordTxt.bounds.height / 2.0
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: -4, bottom: 2, right: 4)
//        button.frame = CGRect(x: 0, y: 0, width: 2, height: 2)
        button.tintColor = .text
        button.setImage(#imageLiteral(resourceName: "password-hide"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "password-show"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = LoginSocialManager.init(facebookButton: loginFacebook, googleButton: loginGoogle, appleButton: loginApple)
        
        passwordTxt.rightView = showHidePasswordButton
        passwordTxt.rightViewMode = .whileEditing
        userNameTxt.delegate = self
        passwordTxt.delegate = self
        loginApple.layer.cornerRadius = 8.0
        loginGoogle.layer.cornerRadius = 8.0
        loginFacebook.layer.cornerRadius = 8.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stopHeadRotation))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        stopHeadRotation()
    }
    
    // MARK: - Action
    @IBAction func signIn(_ sender: Any) {
        // todo
    }
    
    @IBAction func userNameDidChanged(_ sender: UITextField) {
        textFieldDidChanged(sender)
    }
    
    @IBAction func passwordDidChanged(_ sender: UITextField) {
        textFieldDidChanged(sender)
    }
    
    // MARK: - Private function
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isPasswordVisible = sender.isSelected
        passwordTxt.isSecureTextEntry = !isPasswordVisible
        critterView.isPeeking = isPasswordVisible
        
        // 🎩✨ Magic to fix cursor position when toggling password visibility
        if let textRange = passwordTxt.textRange(from: passwordTxt.beginningOfDocument, to: passwordTxt.endOfDocument),
            let password = passwordTxt.text {
            passwordTxt.replace(textRange, withText: password)
        }
    }

}

// MARK: Extension - AuthViewController
private extension LoginViewController {
    func textFieldDidChanged(_ textField: UITextField) {
        guard !critterView.isActiveStartAnimating, textField == userNameTxt else { return }
        
        let fractionComplete = self.fractionComplete(for: textField)
        critterView.updateHeadRotation(to: fractionComplete)
        
        if let text = textField.text {
            critterView.isEcstatic = text.contains("@")
        }
    }
    
    private func fractionComplete(for textField: UITextField) -> Float {
        guard let text = textField.text, let font = textField.font else { return 0 }
        let textFieldWidth = textField.bounds.width
        return min(Float(text.size(withAttributes: [NSAttributedString.Key.font : font]).width / textFieldWidth), 1)
    }
    
    @objc private func stopHeadRotation() {
        userNameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        critterView.stopHeadRotation()
        passwordDidResignAsFirstResponder()
    }
    
    private func passwordDidResignAsFirstResponder() {
        critterView.isPeeking = false
        critterView.isShy = false
        passwordTxt.isSecureTextEntry = true
    }
}

// MARK: Extension - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let deadlineTime = DispatchTime.now() + .milliseconds(100)
        
        if textField == userNameTxt {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                let fractionComplete = self.fractionComplete(for: textField)
                self.critterView.startHeadRotation(startAt: fractionComplete)
                self.passwordDidResignAsFirstResponder()
            }
        }
        else if textField == passwordTxt {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                self.critterView.isShy = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTxt {
            passwordTxt.becomeFirstResponder()
        }
        else {
            passwordTxt.resignFirstResponder()
            passwordDidResignAsFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userNameTxt {
            critterView.stopHeadRotation()
        }
    }
    
}
