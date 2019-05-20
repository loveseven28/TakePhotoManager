//
//  TagViewCell.swift
//  Wecare247
//
//  Created by macOS on 9/7/18.
//  Copyright © 2018 Mac Mini. All rights reserved.
//

import UIKit

protocol TagViewCellDelegate:class {
    func removeTokenAtIndex(index:Int)
}

class TagViewCell: UICollectionViewCell {

    @IBOutlet weak var lbText: UILabel!
    weak var delegate:TagViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func click_remove(_ sender: Any) {
        if let parentView = self.superview as? UICollectionView , let indexPath = parentView.indexPath(for: self) {
            delegate?.removeTokenAtIndex(index: indexPath.row)
        }
    }
}
