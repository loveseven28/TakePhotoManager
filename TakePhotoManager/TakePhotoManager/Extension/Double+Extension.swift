//
//  Double+Extension.swift
//  VoucherMaker
//
//  Created by mac mini on 12/25/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import Foundation
extension Double {
    
    func currency(seperator:Bool = true) -> String{
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = seperator
        formatter.currencySymbol = ""
        let amount = formatter.string(from: self as NSNumber) ?? "0"
        
        return amount + "đ"
    }
    
    func formatNumber(separator:Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = separator
        formatter.numberStyle = .decimal
        let value = formatter.string(from: self as NSNumber) ?? "0"
        return value
    }
    
}
