//
//  GalleryViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 5/21/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit
import FSPagerView
import BSImagePicker
import Photos

class GalleryViewController: BaseViewController {
    @IBOutlet weak var headerCarousel: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    var images: [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [UIImage(named: "1.jpg")!,
                  UIImage(named: "2.jpg")!,
                  UIImage(named: "3.jpg")!,
                  UIImage(named: "4.jpg")!,
                  UIImage(named: "5.jpg")!,
                  UIImage(named: "6.jpg")!,
                  UIImage(named: "7.jpg")!,
                  UIImage(named: "8.jpg")!,
                  UIImage(named: "11.jpg")!,
                  UIImage(named: "9.jpg")!,
                  UIImage(named: "10.jpg")!,
                  UIImage(named: "12.jpg")!,
                  UIImage(named: "13.jpg")!,
                  UIImage(named: "14.jpg")!]
        setUpPageView()
    }
    
    private func setUpPageView() {
        headerCarousel.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        headerCarousel.dataSource = self
        headerCarousel.delegate = self
        headerCarousel.isInfinite = true
        headerCarousel.automaticSlidingInterval = 5.0
        pageControl.numberOfPages = images.count
        pageControl.contentHorizontalAlignment = .center
        
        // Ring
        self.pageControl.setStrokeColor(AppColor.mainColor, for: .normal)
        self.pageControl.setStrokeColor(AppColor.mainColor, for: .selected)
        self.pageControl.setFillColor(AppColor.secondColor, for: .selected)
    }
    
    func showImageAtIndex(index: Int) {
        let photoGallery = PhotoGallery()
        photoGallery.dataSource = self
        photoGallery.delegate = self
        photoGallery.hidePageControl = false
        photoGallery.numberOfImagesTextColor = UIColor(hex: 0x44A2ED)
        photoGallery.backgroundColor = .black
        
        self.present(photoGallery, animated: true) {
            photoGallery.currentPage = index
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        self.images = []
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 10
        vc.takePhotoIcon = UIImage(named: "chat")
        
        vc.albumButton.tintColor = UIColor.green
        vc.cancelButton.tintColor = UIColor.red
        vc.doneButton.tintColor = UIColor.red
        vc.selectionFillColor = AppColor.mainColor
        vc.selectionStrokeColor = UIColor.white
        vc.selectionShadowColor = UIColor.red
        vc.selectionTextAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
            requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.progressHandler = { (progress, error, _, _) in
                print("load image from icloud progress: ", progress)
            }
            // this one is key
            requestOptions.isSynchronous = true
            let myGroup = DispatchGroup()
            for i in 0..<assets.count {
                myGroup.enter()
                if assets[i].mediaType == PHAssetMediaType.image {
                    PHImageManager.default().requestImage(for: assets[i], targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (pickedImage, info) in
                        assets[i].requestContentEditingInput(with: nil, completionHandler: {[weak self] (ContentEditingInput, infoOfThePicture)  in
                            guard let `self` = self else { return }
                            if let imageFile = ContentEditingInput?.fullSizeImageURL {
                                let imageName         = "\(i)_" + imageFile.lastPathComponent
                                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                                let photoURL          = NSURL(fileURLWithPath: documentDirectory)
                                let localPath         = photoURL.appendingPathComponent(imageName)
                                do {
                                    try pickedImage?.jpegData(compressionQuality: 0.5)?.write(to: localPath!)
                                    if let image = pickedImage , let _ = localPath{
                                        self.images.append(image)
                                    }
                                    print("file saved")
                                }catch {
                                    print("error saving file")
                                }
                                
                                myGroup.leave()
                            }
                        })
                    })
                }
                myGroup.notify(queue: .main) {[weak self] in
                    guard let `self` = self else { return }
                    if i == (assets.count - 1) {
                        self.headerCarousel.reloadData()
                        self.setUpPageView()
                        print("COMPLETION Get image")

                    }
                }
            }
        }, completion: nil)

    }
    

}

extension GalleryViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.contentMode = .scaleAspectFill
        if images.count > 0 {
            cell.imageView?.image = images[index]
        }
        return cell
    }
    
    // MARK:- FSPagerViewDelegate
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        self.pageControl.currentPage = index
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        self.showImageAtIndex(index: index)
    }
}

//MARK: PhotoGalleryDelegate
extension GalleryViewController: PhotoGalleryDelegate {
    func photoGallery(_ gallery: PhotoGallery, didTapAt index: Int) {
        gallery.dismiss(animated: true, completion: nil)
    }
}

extension GalleryViewController: PhotoGalleryDataSource {
    func numberOfImages(_ gallery: PhotoGallery) -> Int {
        return images.count
    }
    
    func photoGallery(_ gallery: PhotoGallery, imageAt index: Int) -> UIImage? {
        return images[index]
    }
    
    func photoGallery(_ gallery: PhotoGallery, linkAt index: Int) -> String? {
        return ""
    }
}
