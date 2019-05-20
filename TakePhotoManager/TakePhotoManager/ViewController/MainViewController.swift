//
//  MainViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 5/20/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initMenuView()
        setGradientNavi()
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        self.present(self.menuVC, animated: true, completion:   nil)
    }

    @IBAction func hashTagButtonTapped(_ sender: Any) {
        
    }
}
