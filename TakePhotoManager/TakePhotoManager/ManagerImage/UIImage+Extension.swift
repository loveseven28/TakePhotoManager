//
//  UIImage+Extension.swift
//  CameraManager
//
//  Created by dang hung on 4/16/18.
//  Copyright © 2018 dang hung. All rights reserved.
//

import UIKit
import ImageIO

// MARK: - Properties
public extension UIImage {
    
    /// SwifterSwift: Size in bytes of UIImage
    var bytesSize: Int {
        return self.jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// SwifterSwift: Size in kilo bytes of UIImage
    var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// SwifterSwift: UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
}

// MARK: - Methods
public extension UIImage {
    
    func cropToBounds(width: Double, height: Double) -> UIImage {
        
        let cgimage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            //            posY = ((contextSize.height - contextSize.width) / 2)
            posY = 0
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        return UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
    }
    
    /// SwifterSwift: Compressed UIImage from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional UIImage (if applicable).
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = compressedData(quality: quality) else { return nil }
        return UIImage(data: data)
    }
    
    /// SwifterSwift: Compressed UIImage data from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional Data (if applicable).
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }
    
    /// SwifterSwift: UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.height < size.height && rect.size.height < size.height else { return self }
        guard let image: CGImage = cgImage?.cropping(to: rect) else { return self }
        return UIImage(cgImage: image)
    }
    
    /// SwifterSwift: UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, with orientation: UIImage.Orientation? = nil) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: toHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, with orientation: UIImage.Orientation? = nil) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: toWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context!.clip(to: drawRect, mask: cgImage!)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
    /// SwifterSwift: UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

// MARK: - Initializers
public extension UIImage {
    
    /// SwifterSwift: Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
}

// MARK: Get image extension
enum ImageFormat: String{
    case Unknown = ""
    case PNG = "png"
    case JPG = "jpg"
    case GIF = "gif"
    case TIFF = "tiff"
}

extension Data {
    var format: ImageFormat {
        let array = [UInt8](self)
        switch (array[0]) {
        case 0xFF:
            return .JPG
        case 0x89:
            return .PNG
        case 0x47:
            return .GIF
        case 0x49, 0x4D :
            return .TIFF
        default:
            return .Unknown
        }
    }
}
