//
//  TamOcViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 6/7/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit

class TamOcViewController: BaseViewController {
    @IBOutlet weak var lbTimeElapsed: UILabel!
    @IBOutlet weak var tfTime: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(TamOcCollectionViewCell.nib, forCellWithReuseIdentifier: TamOcCollectionViewCell.reuseIdentifier)
    }
    
    
    @IBAction func didTappedAddTime(_ sender: Any) {
        let string = tfTime.text
        if !(string ?? "").isEmpty {
            let date = string!.convertStringToDate(format: "yyyy-MM-dd'T'HH:mm")
            lbTimeElapsed.text = "".timeAgoSinceDate(date!)
        } else {
            MyAlertController.showAlert(message: "Vui lòng nhập ngày muốn tính")
        }
        
    }
    
}

extension TamOcViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TamOcCollectionViewCell.reuseIdentifier, for: indexPath) as? TamOcCollectionViewCell {
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var totalPadding: CGFloat = 15.0
        var width = (collectionView.frame.size.width - totalPadding) / 3
        let height = ((collectionView.frame.size.height - totalPadding) / 4)
        if height > width {
            totalPadding = 60.0
            width = (collectionView.frame.size.width - totalPadding) / 3
        }
        return CGSize(width: width, height: height)
        
    }
}
