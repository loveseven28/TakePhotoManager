//
//  PreviewImageController.swift
//  KaraKid
//
//  Created by DangHung on 12/15/17.
//  Copyright © 2017 VASTbit. All rights reserved.
//

import UIKit

class PreviewImageController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var doneButton : UIButton!
    var photoCapture : UIImage?
    var didChooseImageFromTakePhotoCamera:((_ image: UIImage) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.closeButton.layer.cornerRadius = 20

        if let photo = photoCapture {
            if let newImage = resizeImage(image: photo, targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)) {
                self.imageView.image = newImage
                
            }
            
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    @IBAction func doneButtonTaped (_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        if let photo = photoCapture {
            if let newImage = resizeImage(image: photo, targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)) {
                self.didChooseImageFromTakePhotoCamera?(newImage)
            }
            
        }

    } 
    
    @IBAction func takeAgainTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
