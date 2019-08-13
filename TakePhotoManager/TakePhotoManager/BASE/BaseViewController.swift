//
//  BaseViewController.swift
//  VLC
//
//  Created by mac mini on 8/29/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import UIKit
import Whisper

extension UIViewController {
    
    static var nib: String {
        return String(describing: self)
    }
    
}

extension BadgeBarButtonItem {
    func updateBadge() {
        
    }
}

class BaseViewController: UIViewController {
    
    var isPresenting:Bool?
    var isHaveShoppingCart:Bool = true
    var menuVC = MenuViewController()
    var interactor = Interactor()
    var cartBarButton = BadgeBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviagtionItem()
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatus(_:)), name: NSNotification.Name(rawValue: "networkChanged"), object: nil)
    }
    
    
    func initMenuView() {
        menuVC = MenuViewController(nibName: MenuViewController.nib, bundle: nil)
        menuVC.transitioningDelegate = self
        menuVC.view.frame = UIScreen.main.bounds
        menuVC.interactor = interactor
    }
    
    func setGradientNavi() {
        self.navigationController?.navigationBar.setGradientBackground(colors: [
            AppColor.firstColor.cgColor,
            AppColor.secondColor.cgColor
            ])
    }
    
    @objc func handleNetworkStatus(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        if let status = userInfo["reachable"] as? String{
            if status == "connected" {
                hide()
            } else if status == "notConnection" {
                let murmur = Murmur(title: "Không có kết nối...",
                                    backgroundColor: UIColor.orange,
                                    titleColor: UIColor.white)
                
                Whisper.show(whistle: murmur, action: .present)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "networkChanged"), object: nil)
    }
    
    func setUpUI() {
        
    }
    func setNaviagtionItem(){
        
        if isPresenting == true {
            addDismissButtonBarItem()
        } else {
            //            addBackButtonBarItem()
        }
    }
    
    @objc func handleCartTapped() {}
    
    func addCartButton() {
        cartBarButton = BadgeBarButtonItem(image: #imageLiteral(resourceName: "ic-cart-white"), target: self, action: #selector(handleCartTapped))
        self.navigationItem.rightBarButtonItems = [cartBarButton]
    }
    
    func barButtonItem(iconName:String,target:Any,action:Selector) -> UIBarButtonItem {
        
        let buttonItem:UIButton = UIButton(frame: CGRect(x:0,y:0,width:30,height:30))
        buttonItem.setImage(UIImage.init(named: iconName), for: .normal)
        buttonItem.contentHorizontalAlignment = .left
        
        buttonItem.addTarget(target, action:action,for:.touchUpInside)
        buttonItem.applyNavBarConstraints(size: (width: 30, height: 30))
        
        return UIBarButtonItem.init(customView: buttonItem)
    }
    
    fileprivate func addDismissButtonBarItem(){
        let barItem = barButtonItem(iconName: "ic-dismiss",target: self, action: #selector(handleDismissViewController))
        self.navigationItem.leftBarButtonItems = [barItem]
    }
    
    func addBackButtonBarItem() {
        let backButtonBarItem = barButtonItem(iconName: "ic-back",target: self, action: #selector(backToViewController))
        self.navigationItem.leftBarButtonItems = [backButtonBarItem]
    }
    
    
    @objc func handleDismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backToViewController(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    func checkUserLogin() -> Bool {
        if let isLogin = SettingsApp.isUserLogged {
           return isLogin
        } else {
            return false
        }
    }
    
    func clearDataLocal() {
        NOTI_NUMBER = 0
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notiNumber"), object: nil, userInfo: ["number":0])
        UIApplication.shared.applicationIconBadgeNumber = 0
//        MagicalRecord.save({ (context) in
//            Cart.mr_truncateAll(in: context)
//        }) { (success, error) in
//            if success {
//                SettingsApp.totalCartNumber = 0
//                self.cartBarButton.updateBadge()
//            }
//        }
    }
    
    func getNumberNoti() {
       
    }
    
    class func lock(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    class func lock(_ orientation: UIInterfaceOrientationMask, rotate: UIInterfaceOrientation) {
        lock(orientation)
        UIDevice.current.setValue(rotate.rawValue, forKey: "orientation")
    }
}

//MARK: UIViewControllerTransitioningDelegate
extension BaseViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let _ = presented as? MenuViewController {
            return PresentMenuAnimator()
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let _ = dismissed as? MenuViewController {
            return DismissMenuAnimator()
        }
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}



extension UIViewController {
    
    func addSearchBar(searchBar:UISearchBar) {
        let width = UIScreen.main.bounds.width
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.borderStyle = .none
            textfield.backgroundColor = .clear
            textfield.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder ?? "Tìm kiếm",
                                                                 attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            textfield.textColor = UIColor.darkGray
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width - 120, height: 30))
        searchBar.frame = view.frame
        searchBar.setSearchIcon(color: UIColor.lightGray)
        searchBar.setClearButtonColorTo(color: UIColor.red)
        view.backgroundColor = .white
        view.addSubview(searchBar)
        
        view.layer.cornerRadius = view.frame.size.height / 2
        view.clipsToBounds = true
        view.shadowButton()
        let button = UIButton(frame: view.frame)
        button.addTarget(self, action: #selector(handleTapSearchBar), for: .touchUpInside)
        view.addSubview(button)
        self.navigationItem.titleView = view
        
    }
    
    @objc func handleTapSearchBar() {
        
    }
    
    func addSearchBarGray(searchBar:UISearchBar) {
        
        let width = UIScreen.main.bounds.width
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.borderStyle = .none
            textfield.backgroundColor = .clear
            let font = AppFont.Roboto.font(ofSize: 14, weight: .Regular)
            let attr = [NSAttributedString.Key.foregroundColor : UIColor.lightGray,
                        NSAttributedString.Key.font: font]
            
            textfield.attributedPlaceholder = NSAttributedString(string: searchBar.placeholder ?? " Tìm kiếm",
                                                                 attributes: attr)
            textfield.textColor = UIColor.darkGray
            textfield.font = font
            textfield.leftViewMode = .always
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width - 70, height: 34))
        searchBar.frame = view.frame
        searchBar.setSearchIcon(color: UIColor.gray)
        searchBar.setClearButtonColorTo(color: UIColor.red)
        view.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(searchBar)
        
        view.layer.cornerRadius = view.frame.size.height / 2
        view.clipsToBounds = true
        self.navigationItem.titleView = view
        
    }
    
    @objc func hiddenKeyboard() {
        
        
    }
    
}

extension UIView {
    
    func applyNavBarConstraints(size: (width: Float, height: Float)) {
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: CGFloat(size.width))
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: CGFloat(size.height))
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
}

extension UISearchBar {
    func setSearchIcon(color: UIColor)
    {
        // Search Icon
        var view: UIView
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = glassIconView?.image
        imageView.tintColor = color
        imageView.contentMode = .scaleAspectFit
        let width = imageView.frame.width + 10
        view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        view.addSubview(imageView)
        textFieldInsideSearchBar?.leftView = view
    }
    
    func setLeftImageGlass() {
        
        var view = UIView()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = #imageLiteral(resourceName: "ic-search")
        
        imageView.tintColor = UIColor.lightGray
        imageView.contentMode = .scaleAspectFit
        var width = imageView.frame.width
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        if textFieldInsideSearchBar?.borderStyle == UITextField.BorderStyle.none || textFieldInsideSearchBar?.borderStyle == UITextField.BorderStyle.line {
            width += 5
        }
        view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        view.addSubview(imageView)
        
        textFieldInsideSearchBar?.leftView = view
    }
    
    func setClearButtonColorTo(color: UIColor)
    {
        // Clear Button
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let crossIconView = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton
        crossIconView?.setImage(crossIconView?.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        crossIconView?.tintColor = color
    }
    
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
}


