//
//  UINavigation+Extension.swift
//  TTS
//
//  Created by mac mini on 1/21/19.
//  Copyright © 2019 mac mini. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    func setGradientBackground(colors: [Any]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        var updatedFrame = self.bounds
        updatedFrame.size.height += self.frame.origin.y
        gradient.frame = updatedFrame
        gradient.colors = colors;
        self.setBackgroundImage(self.image(fromLayer: gradient), for: .default)
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
}
