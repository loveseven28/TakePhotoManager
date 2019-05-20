//
//  MenuViewController.swift
//  RealEstate_AR-VR
//
//  Created by DangHung on 1/3/18.
//  Copyright © 2018 VASTbit. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewController(dismiss: MenuViewController)
    func openSegue(_ segueName: String, sender: AnyObject?)
    func reopenMenu()
    func menuViewController(_ controller: MenuViewController, didSelectRowAt indexPath: IndexPath)
}

struct MenuItem {
    let iconImage: UIImage
    let name: String
}

enum MenuCase: Int {
    case Home    = 0
    case All     = 1
    case Contact = 2
    case Bill    = 3
    case Cart    = 4
    case Noti    = 5
    case Setting = 6
    case Logout  = 7
}

class MenuViewController: UIViewController {
    @IBOutlet weak var userImageView: MyImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

 
    var arrMenu: [MenuItem] = []

    weak var delegate : MenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.imageView.image = #imageLiteral(resourceName: "ic-user-default")
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
    }
    
    deinit {
        print("Menu die")
    }
    
    private func setUpView() {
        if let login = SettingsApp.isUserLogged, login {
            emailLabel.text = "SettingsApp.UserInfo?.email"
            userNameLabel.text = "SettingsApp.UserInfo?.name"
            userImageView.loadImageUrl(url: "SettingsApp.UserInfo?.avatarUrl")
        } else {
            emailLabel.text = "Đăng nhập"
            userNameLabel.text = "Tài khoản"
            userImageView.setImage(image: #imageLiteral(resourceName: "ic-user-default"))
        }
        
        if let login = SettingsApp.isUserLogged, login {
            arrMenu = [MenuItem(iconImage: #imageLiteral(resourceName: "menu-hone"), name: "Trang chủ"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-all"), name: "Tất cả danh mục"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-contact"), name: "Liên hệ"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-bill"), name: "Đơn hàng"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-cart"), name: "Giỏ hàng"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-noti"), name: "Thông báo"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-setting"), name: "Cài đặt tài khoản"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-logout"), name: "Đăng xuất")]
        } else {
            arrMenu = [MenuItem(iconImage: #imageLiteral(resourceName: "menu-hone"), name: "Trang chủ"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-all"), name: "Tất cả danh mục"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-contact"), name: "Liên hệ"),
                       MenuItem(iconImage: #imageLiteral(resourceName: "menu-noti"), name: "Thông báo")]
        }
        self.tableView.reloadData()

    }
    
    private func initTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(MenuTableViewCell.nib, forCellReuseIdentifier: MenuTableViewCell.reuseIdentifier)
    }
    
  
    weak var interactor: Interactor?
    
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor) {
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if !SettingsApp.checkUserLogin() {
            self.dismiss(animated: true) {
                
            }
        }
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        dismiss(animated: true){
            self.delay(seconds: 0.5){
                self.delegate?.reopenMenu()
            }
        }
    }
    
    private func confirmLogOut() {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn đăng xuất?", preferredStyle: .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
        }
        let action = UIAlertAction(title: "Đăng Xuất", style: .default) {[weak self] (action) in
            guard let `self` = self else { return }
            self.doLogout()
        }
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        action.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(action)
        alert.addAction(cancelAction)
        if let topview = UIWindow.topViewController() {
            topview.present(alert, animated: true, completion: nil)
        }
    }
    
    private func doLogout() {
        
        
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.reuseIdentifier, for: indexPath) as? MenuTableViewCell {
            cell.item = arrMenu[indexPath.row]
            cell.selectionStyle = .gray
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case MenuCase.Home.rawValue:
            self.dismiss(animated: true) {
                
            }
        case MenuCase.All.rawValue:
            self.dismiss(animated: true) {
                
            }
        case MenuCase.Contact.rawValue:
            self.dismiss(animated: true) {
                
            }
        case MenuCase.Bill.rawValue:
            self.dismiss(animated: true) {
                
            }
        case MenuCase.Cart.rawValue:
            self.dismiss(animated: true) {
                
            }
        case MenuCase.Noti.rawValue:
            self.dismiss(animated: true) {
                
            }
        case MenuCase.Setting.rawValue:
            self.dismiss(animated: true) {
                
            }
        case MenuCase.Logout.rawValue:
            self.dismiss(animated: true) {[weak self] in
                self?.confirmLogOut()
            }
        default:
            break
        }
    }
}
