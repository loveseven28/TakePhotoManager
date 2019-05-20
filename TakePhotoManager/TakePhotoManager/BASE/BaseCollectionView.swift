//
//  BaseCollectionView.swift
//  NutriHouse
//
//  Created by Vuong Nguyen on 3/23/18.
//  Copyright © 2018 Vuong Nguyen. All rights reserved.
//

import UIKit

protocol BaseCollectionViewCellDelegate: class {
    
}

public class BaseCollectionViewCell: UICollectionViewCell {
    
    class internal var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
    
    weak internal var viewDelegate: BaseCollectionViewCellDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initComponent()
    }
    
    internal func initComponent() { }
    
    internal func getCellSize() -> CGSize { return CGSize.zero }
    
  
}
