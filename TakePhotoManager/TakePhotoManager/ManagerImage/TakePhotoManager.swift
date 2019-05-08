//
//  TakePhotoManager.swift
//  KaraKid
//
//  Created by DangHung on 11/27/17.
//  Copyright © 2017 VASTbit. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol TakePhotoManagerDelegate: class {
    func imageDidGet(image: UIImage)
}

class TakePhotoManager: UIViewController{
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var TakeImgeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    weak var delegate : TakePhotoManagerDelegate?
    var captureSession = AVCaptureSession()
    var currentCameraPosition : AVCaptureDevice.Position = .front
    var captureSessionQueue : DispatchQueue!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var photoDataOutput: AVCapturePhotoOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkPemisstion()
        self.shadowButton()
        self.closeButton.layer.cornerRadius = 23
        self.switchButton.layer.cornerRadius = 23
    }

    public func shadowButton() {
        TakeImgeButton.layer.shadowColor = UIColor.black.cgColor
        TakeImgeButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        TakeImgeButton.layer.shadowOpacity = 0.5
        TakeImgeButton.layer.shadowRadius = 4.0
        TakeImgeButton.layer.masksToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        videoPreviewLayer?.frame = view.bounds
        if let previewLayer = videoPreviewLayer ,(previewLayer.connection?.isVideoOrientationSupported)! {
            previewLayer.connection?.videoOrientation = UIApplication.shared.statusBarOrientation.videoOrientation ?? .portrait
        }
    }
    
    private func checkPemisstion() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            if setupSession() {
                self.setupPreviewLayer()
            }
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) {[weak self] granted in
                guard let `self` = self else { return }
                if granted {
                    if self.setupSession() {
                        self.setupPreviewLayer()
                    }
                } else {
                    self.camDenied()
                }
            }
        case .denied: // The user has previously denied access.
            self.camDenied()
        case .restricted: // The user can't grant access due to restrictions.
            let alert = UIAlertController(title: "Restricted",
                                          message: "You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access.",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
  
    func takeImageFromCamera() -> UIImagePickerController? {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.showsCameraControls = true
            imagePicker.allowsEditing = true
            return imagePicker
        }
        return nil
    }
    
    func chooseImageFromLibraryDevice() -> UIImagePickerController? {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            return imagePicker
        }
        return nil
    }
    
    func camDenied()
    {
        DispatchQueue.main.async
            {
                var alertText = "It looks like your privacy settings are preventing us from accessing your camera to do image taking. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera on.\n\n5. Open this app and try again."
                
                var alertButton = "OK"
                var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
                
                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
                {
                    alertText = "It looks like your privacy settings are preventing us from accessing your camera to do image taking. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again."
                    
                    alertButton = "Go"
                    
                    goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                }
                
                let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: .alert)
                alert.addAction(goAction)
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //custom camera
    
    private func setupSession() -> Bool {
        //        captureSession.sessionPreset = AVCaptureSession.Preset.high
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return false }
        
        //setup camera
        do {
            let videoInput = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        } catch {
            print("Error setting device video input \(error.localizedDescription)")
            return false
        }
        
        photoDataOutput = AVCapturePhotoOutput()
        
        if captureSession.canAddOutput(photoDataOutput) {
            captureSession.addOutput(photoDataOutput)
            
        }
        
        return true
    }
    
    private func switchCamera() {
        //Indicate that some changes will be made to the session
        captureSession.beginConfiguration()
        
        //Remove exist device input
        let currentInputs = captureSession.inputs
        var currentCameraInput: AVCaptureDeviceInput?
        
        for item in currentInputs {
            if let input = item as? AVCaptureDeviceInput, input.device.hasMediaType(.video) {
                captureSession.removeInput(item)
                currentCameraInput = input
            }
        }
        
        //Create new camera position
        var newCamera: AVCaptureDevice! = nil
        if let input = currentCameraInput {
            input.device.hasMediaType(.video)
            if input.device.position == .back {
                newCamera = cameraWith(postion: .front)
                currentCameraPosition = .front
            } else {
                newCamera = cameraWith(postion: .back)
                currentCameraPosition = .back
            }
        }
        
        //New input
        var newVideoInput: AVCaptureDeviceInput! = nil
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch {
            print("Couldn't create new camera \(error.localizedDescription)")
        }
        
        if let newInput = newVideoInput {
            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
            }
        }
        
        captureSession.commitConfiguration()
    }
    
    private func cameraWith(postion: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == postion {
                return device
            }
        }
        
        return nil
    }
    
    private func setupPreviewLayer() {
        videoPreviewLayer =  AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = self.previewView.layer.bounds
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewView.layer.addSublayer(videoPreviewLayer)
        
        self.startSession()
    }
    
    private func setVideoMode(_ mode: Int) {
        //Video Mode
    }
    
    private func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    private func startSession() {
        if !captureSession.isRunning {
            videoQueue().async { [weak self] in
                guard let `self` = self else { return }
                self.captureSession.startRunning()

            }
        }
    }
    
    private func stopSession() {
        if !captureSession.isRunning {
            videoQueue().async { [weak self] in
                guard let `self` = self else { return }
                self.captureSession.stopRunning()
            }
        }
    }
    @IBAction func takePhoto(_ sender: Any) {
        
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.photoDataOutput else { return }
        
//        let settings = AVCapturePhotoSettings()
//        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
//        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//                             kCVPixelBufferWidthKey as String: 375,
//                             kCVPixelBufferHeightKey as String: 667]
//        settings.previewPhotoFormat = previewFormat
        
        if #available(iOS 11.0, *) {
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
            capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        } else {
            let photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])
            capturePhotoOutput.capturePhoto(with: photoSetting, delegate: self)
        }

        
        // Call capturePhoto method by passing our photo settings and a delegate implementing AVCapturePhotoCaptureDelegate
    }
    
    @IBAction func changeCameraSwitchTaped(_ sender: UIButton) {
        self.switchCamera()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
}

extension TakePhotoManager : AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
    
    
}

extension TakePhotoManager: AVCapturePhotoCaptureDelegate {
    @available(iOS 10.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        if let sampleBuffer = photoSampleBuffer, let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer), let image = UIImage(data: imageData) {
            var imageTemp = UIImage()
            if self.currentCameraPosition == .front {
                imageTemp = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .leftMirrored)
            }else {
                imageTemp = image
            }
            
            //Crop Image
            let cropImageVC = CropImageViewController(nibName: "CropImageViewController", bundle: nil)
            cropImageVC.photoCapture = imageTemp
            cropImageVC.didChooseImageCrop = {[weak self] (image) in
                guard let `self` = self else { return }
                self.delegate?.imageDidGet(image: image)
                self.dismiss(animated: true, completion: nil)
            }
            self.present(cropImageVC, animated: true, completion: nil)
        }

    }
    

    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let photo = photo.fileDataRepresentation() {
            let capturedImage = UIImage.init(data: photo , scale: 1.0)
            if let image = capturedImage {
                var imageTemp = UIImage()
                if self.currentCameraPosition == .front {
                    imageTemp = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .leftMirrored)
                }else {
                    imageTemp = image
                }
                //Dont crop image
//                let previewImageVC = PreviewImageController(nibName: "PreviewImageController", bundle: nil)
//                previewImageVC.photoCapture = imageTemp
//                previewImageVC.didChooseImageFromTakePhotoCamera = {[weak self] (image) in
//                    guard let `self` = self else { return }
//                    self.delegate?.imageDidGet(image: image)
//                    self.dismiss(animated: true, completion: nil)
//                }
//                self.present(previewImageVC, animated: true, completion: nil)
                
                //Crop Image
                let cropImageVC = CropImageViewController(nibName: "CropImageViewController", bundle: nil)
                cropImageVC.photoCapture = imageTemp
                cropImageVC.didChooseImageCrop = {[weak self] (image) in
                    guard let `self` = self else { return }
                    self.delegate?.imageDidGet(image: image)
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(cropImageVC, animated: true, completion: nil)
            }
        }
        
    }
    
}

extension UIInterfaceOrientation {
    var videoOrientation: AVCaptureVideoOrientation? {
        switch self {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
}




