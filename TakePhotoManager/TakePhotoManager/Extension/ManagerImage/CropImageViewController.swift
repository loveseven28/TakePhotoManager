//
//  CropImageViewController.swift
//  KaraKid
//
//  Created by DangHung on 12/14/17.
//  Copyright © 2017 VASTbit. All rights reserved.
//

import UIKit

class CropImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 10.0
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cropButton : UIButton!
    let cropAreaView : UIView = {
        let v = UIView()
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 1.0
        v.backgroundColor = .clear
        
        return v
    }()
    
    var photoCapture : UIImage?
    var layerCrop = CAShapeLayer()
    var didChooseImageCrop:((_ image: UIImage) -> Void)?
    var cropArea:CGRect{
        get{
            let factor = imageView.image!.size.width/view.frame.width
            let scale = 1/scrollView.zoomScale
            let imageFrame = imageView.imageFrame()
            let x = (scrollView.contentOffset.x + (self.view.center.x - self.view.frame.size.width / 2) - imageFrame.origin.x) * scale * factor
            let y = (scrollView.contentOffset.y + (self.view.center.y - self.view.frame.size.width / 2) - imageFrame.origin.y) * scale * factor
            let width = view.frame.size.width * scale * factor
            let height = view.frame.size.width * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photoCapture {
            if let newImage = resizeImage(image: photo, targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)) {
                self.imageView.image = newImage
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpView()
    }
    
    private func setUpView() {
        layerCrop.path = UIBezierPath(roundedRect: CGRect(x: self.view.center.x - self.view.frame.size.width / 2 , y: self.view.center.y - self.view.frame.size.width / 2, width: self.view.frame.size.width, height: self.view.frame.size.width), cornerRadius: 0).cgPath
        layerCrop.fillColor = nil
        layerCrop.strokeColor = UIColor.white.cgColor
        view.layer.addSublayer(layerCrop)
        
        
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let frame = CGRect(x: self.view.center.x - self.view.frame.size.width / 2 , y: self.view.center.y - self.view.frame.size.width / 2, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        scrollView.contentInset = calculateScrollViewInsets(frame)
        centerScrollViewContents()
    }
    
    private func centerScrollViewContents() {
        let size = scrollView.contentInset.bottom
        var imageOrigin = CGPoint.zero
        imageOrigin.y = -size
        imageView.frame.origin = imageOrigin
        scrollView.scrollRectToVisible(CGRect(x: 0, y: -size, width: imageView.frame.size.width, height: imageView.frame.size.height), animated: false)
    }
    
    
    private func calculateScrollViewInsets(_ frame: CGRect) -> UIEdgeInsets {
        let bottom = view.frame.height - (frame.origin.y + frame.height)
        let right = view.frame.width - (frame.origin.x + frame.width)
        let insets = UIEdgeInsets(top: frame.origin.y, left: frame.origin.x, bottom: bottom, right: right)
        return insets
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
    
    func translationY(viewY: CGFloat) -> CGFloat {
        if viewY < (self.cropAreaView.frame.size.height / 2) {
            return (self.cropAreaView.frame.size.height / 2)
        }
        if viewY > (UIScreen.main.bounds.height - (self.cropAreaView.frame.size.height / 2)) {
            return (UIScreen.main.bounds.height - (self.cropAreaView.frame.size.height / 2))
        }
        
        return viewY
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func cropImage() {
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: cropArea)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        imageView.image = croppedImage
        scrollView.zoomScale = 1
        layerCrop.removeFromSuperlayer()
        self.dismiss(animated: true, completion: nil)
        self.didChooseImageCrop?(croppedImage)
    }
    
    @IBAction func crop(_ sender: UIButton) {
        cropImage()
    }
    
    @IBAction func takeAgainButtonTaped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}

extension CropImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
