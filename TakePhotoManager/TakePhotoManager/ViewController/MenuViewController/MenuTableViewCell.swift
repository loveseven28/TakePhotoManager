//
//  MenuTableViewCell.swift
//  VoucherMaker
//
//  Created by mac mini on 12/3/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import UIKit

class MenuTableViewCell: BaseTableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    var item: MenuItem? {
        didSet {
            if let item = item {
                self.setUpView(data: item)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setUpView(data: MenuItem) {
        iconImageView.image = data.iconImage
        lbName.text = data.name
    }
    
}
