//
//  ViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 5/8/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var takePhotoButton: UIButton!
    var cameraManager: CameraManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraManager = CameraManager(chooseImageButton: takePhotoButton, rootViewController: self)
        cameraManager!.delegate = self
//        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
    }
}

extension ViewController: CameraManagerDelegate {
    func cameraManager(_ cameraManager: CameraManager, didChoose image: UIImage) {
        
    }
    
    func cameraManager(_ cameraManagerDidCancel: CameraManager) {
        
    }
    
    
}

