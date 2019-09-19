//
//  ChatRightTVCell.swift
//  AppChat
//
//  Created by dang hung on 10/7/18.
//  Copyright © 2018 dang hung. All rights reserved.
//

import UIKit

class ChatRightTVCell: BaseTableViewCell {
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.transform = CGAffineTransform(scaleX: 1, y: -1)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
