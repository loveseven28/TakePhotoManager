//
//  ViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 5/8/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var avatarView1: UIViewX!
    @IBOutlet weak var avatarView2: UIViewX!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    var cameraManager: CameraManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraManager = CameraManager(chooseImageButton: takePhotoButton, rootViewController: self)
        cameraManager!.delegate = self
//        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cropAvatar()
    }
    
    private func cropAvatar() {
        avatarView1.cornerRadius = avatarView1.frame.size.width / 2
        avatarView2.cornerRadius = avatarView2.frame.size.width / 2
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarView1.shadowView()
        
    }
    
}

extension ViewController: CameraManagerDelegate {
    func cameraManager(_ cameraManager: CameraManager, didChoose image: UIImage) {
        self.avatarImageView.image = image
    }
    
    func cameraManager(_ cameraManagerDidCancel: CameraManager) {
        
    }
    
    
}

