//
//  CritterAssets.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit


extension UIImage {

    struct Critter {
        static let body = #imageLiteral(resourceName: "body")
        static let doeEye = #imageLiteral(resourceName: "eye")
        static let eye = #imageLiteral(resourceName: "eye-doe")
        static let head = #imageLiteral(resourceName: "face")
        static let leftArm = #imageLiteral(resourceName: "arm")
        static let leftEar = #imageLiteral(resourceName: "ear")
        static let mouthCircle = #imageLiteral(resourceName: "mouth-circle")
        static let mouthFull = #imageLiteral(resourceName: "mouth-open")
        static let mouthHalf = #imageLiteral(resourceName: "mouth-half")
        static let mouthSmile = #imageLiteral(resourceName: "mouth-smile")
        static let muzzle = #imageLiteral(resourceName: "muzzle")
        static let nose = #imageLiteral(resourceName: "nose")
        
        static let rightEar: UIImage = {
            let leftEar = UIImage.Critter.leftEar
            return UIImage(
                cgImage: leftEar.cgImage!,
                scale: leftEar.scale,
                orientation: .upMirrored
            )
        }()
        
        static let rightArm: UIImage = {
            let leftArm = UIImage.Critter.leftArm
            return UIImage(
                cgImage: leftArm.cgImage!,
                scale: leftArm.scale,
                orientation: .upMirrored
            )
        }()
    }
}
