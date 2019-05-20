//
//  MyImageView.swift
//  Shop
//
//  Created by macOS on 12/17/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import UIKit
import Kingfisher


@IBDesignable
class MyImageView: ViewBase {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageViewX!
    
    func loadImageUrl(url:String) {
        self.loading.startAnimating()
        self.loading.hidesWhenStopped = true
        self.imageView.kf.setImage(with: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.convertToUrl(), placeholder: #imageLiteral(resourceName: "default")) { (_) in
            self.loading.stopAnimating()
        }
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image
    }
}
