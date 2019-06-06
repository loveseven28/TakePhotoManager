//
//  GalleryViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 5/21/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit
import FSPagerView

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
