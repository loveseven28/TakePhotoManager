//
//  BaseTableViewCell.swift
//  NutriHouse
//
//  Created by Vuong Nguyen on 3/23/18.
//  Copyright © 2018 Vuong Nguyen. All rights reserved.
//

import UIKit

protocol BaseTableViewCellDelegate: class {
    
}
public class BaseTableViewCell: UITableViewCell {
    
    class internal var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static internal var nib: UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
    
    weak internal var viewDelegate: BaseTableViewCellDelegate?
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initComponent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initComponent()
    }
    
    internal func initComponent() { }
    
    internal func getCellSize() -> CGSize { return CGSize.zero }
}
