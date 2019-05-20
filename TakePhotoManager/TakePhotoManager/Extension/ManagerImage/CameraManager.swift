//
//  CameraManager.swift
//  CameraManager
//
//  Created by dang hung on 3/12/18.
//  Copyright © 2018 dang hung. All rights reserved.
//

import UIKit
@objc protocol CameraManagerDelegate {
    func cameraManager(_ cameraManager: CameraManager, didChoose image: UIImage)
    func cameraManager(_ cameraManagerDidCancel: CameraManager)
    @objc optional func cameraManager(_ cameraManager: CameraManager, didSave image: UIImage, withDirectory path: URL)
}
class CameraManager: NSObject{
    var delegate: CameraManagerDelegate?
    let rootViewController: UIViewController
    let chooseImageButton : UIButton
    init(chooseImageButton: UIButton, rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.chooseImageButton = chooseImageButton
        super.init()
        self.chooseImageButton.addTarget(self, action: #selector(chooseImageTaped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc
    func chooseImageTaped(_ sender: UIButton) {
        self.showAlertChangeAvatar()
    }
    
    private func showAlertChangeAvatar() {
        let alert = UIAlertController()
        let action = UIAlertAction(title: "Chụp hình", style: .default) {[weak self] (action) in
            guard let `self` = self else { return }
            self.takeImageFromCamera()
            
        }
        let action1 = UIAlertAction(title: "Chọn từ thư viện ảnh", style: .default) {[weak self] (action) in
            guard let `self` = self else { return }
            self.chooseImageFromLibrary()
            
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(action1)
        alert.addAction(action2)
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    private func takeImageFromCamera() {
        let takePhoto = TakePhotoManager(nibName: "TakePhotoManager", bundle: nil)
        takePhoto.delegate = self
        rootViewController.present(takePhoto, animated: true, completion: nil)
    }
    
    private func chooseImageFromLibrary() {
        self.showLoading()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.navigationBar.tintColor = UIColor.orange
            rootViewController.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    private func showLoading() {
        let blurView = UIView()
        blurView.frame = rootViewController.view.bounds
        blurView.backgroundColor = UIColor.black
        blurView.alpha = 0.4
        blurView.tag = 999
        let loading = UIActivityIndicatorView(style: .whiteLarge)
        blurView.addSubview(loading)
        loading.center = blurView.center
        loading.startAnimating()
        rootViewController.view.addSubview(blurView)
    }
    
    private func hideLoading() {
        for view in rootViewController.view.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
    }
    
    private func saveImageToDocumentDirectory(image: UIImage) {
        let data: Data = image.pngData()!
        let imageName         = "\(randomString(length: 12)).\(data.format)"
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        if let localPath      = photoURL.appendingPathComponent(imageName) {
            if !FileManager.default.fileExists(atPath: localPath.path) {
                do {
                    try image.jpegData(compressionQuality: 0.3)?.write(to: localPath)
                    print("file saved")
                }catch {
                    print("error saving file")
                }
            }
            else {
                print("file already exists")
            }
        }
    }
    
    private  func saveImage(image: UIImage?) {
        if let image = image {
            let imageData = image.jpegData(compressionQuality: 0.6)
            if let JPGImage = imageData {
                if let compressedJPGImage = UIImage(data: JPGImage) {
                    UIImageWriteToSavedPhotosAlbum(compressedJPGImage, nil, nil, nil)
                    
                }
            }
            
        }
    }
    
    public func clearDocumentFolder() {
        let fileManger = FileManager.default
        let documentPath = fileManger.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        
        do {
            let filePaths = try fileManger.contentsOfDirectory(atPath: documentPath)
            for filePath in filePaths {
                try fileManger.removeItem(atPath: documentPath + "/\(filePath)")
            }
        } catch {
            print("Could not clear document folder: \(error)")
        }
    }
    
    private func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

extension CameraManager : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if picker.sourceType == .photoLibrary {
                self.delegate?.cameraManager(self, didChoose: image)
                self.hideLoading()
//                self.saveImageToDocumentDirectory(image: image)
            }
            
        }
        rootViewController.dismiss(animated: true, completion: nil)
        
    }
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        rootViewController.dismiss(animated: true, completion: nil)
        self.hideLoading()
        self.delegate?.cameraManager(self)
    }
}

extension CameraManager: TakePhotoManagerDelegate {
    func imageDidGet(image: UIImage) {
        self.delegate?.cameraManager(self, didChoose: image)
//        self.saveImageToDocumentDirectory(image: image)
    }
}


extension String {
    var fileName: String? {
        if let fileName = URL(string: self)?.deletingPathExtension().lastPathComponent {
            return fileName
        } else {
            return nil
        }
    }
    
    var fileExtension: String? {
        if let fileExtensin = URL(string: self)?.pathExtension {
            return fileExtensin
        } else {
            return nil
        }
    }
}
