//
//  ChildViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 5/21/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit

class ChildViewController: BaseViewController {
    let listItemVC = ListItemViewController(nibName: ListItemViewController.nib,bundle:nil)
    var heightCalendarConstraint: NSLayoutConstraint! = NSLayoutConstraint()
    override func viewDidLoad() {
        super.viewDidLoad()
        heightCalendarConstraint.constant = UIScreen.main.bounds.height / 2
        addBottomSheetView()
        listItemVC.initView()
    }
    
    func addBottomSheetView() {
        self.addChild(listItemVC)
        listItemVC.view.frame = self.view.frame
        self.view.addSubview(listItemVC.view)
        listItemVC.didMove(toParent: self)
    }

}
