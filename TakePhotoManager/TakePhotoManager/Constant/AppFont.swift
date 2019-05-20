//
//  AppFont.swift
//  RealEstate_AR-VR
//
//  Created by Vuong Nguyen on 1/10/18.
//  Copyright © 2018 VASTbit. All rights reserved.
//

import UIKit

enum AppFont: String {
    case HelveticaNeue = "HelveticaNeue"
    case Roboto = "Roboto"
    
    func font(ofSize: CGFloat = 17.0, weight: FontWeight = .Regular) -> UIFont {
        return UIFont(name: self.rawValue + "-\(weight)", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }
}

enum FontWeight: String {
    case Regular = "Regular"
    case Italic = "Italic"
    case UltraLight = "UltraLight"
    case UltraLightItalic = "UltraLightItalic"
    case Thin = "Thin"
    case ThinItalic = "ThinItalic"
    case Light = "Light"
    case LightItalic = "LightItalic"
    case Medium = "Medium"
    case MediumItalic = "MediumItalic"
    case Bold = "Bold"
    case BoldItalic = "BoldItalic"
    case CondensedBook = "CondensedBook"
    case CondensedBlack = "CondensedBlack"
}

