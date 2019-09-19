//
//  ListGroupTableViewCell.swift
//  TakePhotoManager
//
//  Created by HoanVu on 9/19/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit

class ListGroupTableViewCell: BaseTableViewCell {
    var numberUser: Int = 2 {
        didSet {
            self.setUpView()
        }
    }
    @IBOutlet weak var imageView1: UIImageViewX!
    @IBOutlet var imageView2: [UIImageViewX]!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setUpView() {
        if numberUser == 2 {
            for item in imageView2 {
                item.isHidden = true
            }
        } else if numberUser == 3 {
            for i in 0..<imageView2.count {
                if i == 1 {
                    imageView2[1].isHidden = true
                } else {
                    imageView2[i].isHidden = false
                }
            }
            imageView1.isHidden = true
        } else if numberUser == 4 {
            for item in imageView2 {
                item.isHidden = false
            }
            imageView1.isHidden = true
        }
    }
    
}
