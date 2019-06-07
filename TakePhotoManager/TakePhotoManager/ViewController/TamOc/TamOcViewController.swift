//
//  TamOcViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 6/7/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit

class TamOcViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(TamOcCollectionViewCell.nib, forCellWithReuseIdentifier: TamOcCollectionViewCell.reuseIdentifier)
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
        
        let width = (collectionView.frame.size.width) / 3
        let height = ((collectionView.frame.size.height) / 4)
        //        return CGSize(width: 80, height: 80)
        print(width)
        print(height)
        return CGSize(width: width, height: height)
        
    }
}
