//
//  MyCollectionView.swift
//  VoucherMaker
//
//  Created by mac mini on 12/19/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import UIKit

protocol MyCollectionViewDelegate {
    
    func isHaveData() -> Bool
    
    func handleRefreshControl()
}

class MyCollectionView: UICollectionView {
    
    let myRefreshControl = UIRefreshControl()
    var page:Int = 0 {
        didSet {
            isLoadingMore = true
        }
    }
    var totalPage = 0
    var isLoadingMore: Bool = false
    var emptyView = EmptyView()
    var myDelegate: MyCollectionViewDelegate?
    
    func setUpUI() {
        self.myRefreshControl.tintColor = UIColor.gray
        self.alwaysBounceVertical = true
        self.myRefreshControl.addTarget(self, action: #selector(handlePulltoRefresh), for: .valueChanged)
        self.addSubview(myRefreshControl)
        self.register(UINib(nibName: "FooterLoadMoreView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterLoadMoreView")
        if let d = self.viewController as? MyCollectionViewDelegate {
            self.myDelegate = d
        }
    }
    
    override func reloadData() {
        isLoadingMore = false
        if myDelegate?.isHaveData() == false {
            emptyView.frame = self.frame
            self.addSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
        }
        super.reloadData()
    }
    
    @objc
    func handlePulltoRefresh() {
        emptyView.removeFromSuperview()
        self.page = 0
        self.totalPage = 0
        self.myDelegate?.handleRefreshControl()
    }
    
    func allowLoadMore() -> Bool {
        if page < totalPage && isLoadingMore == false {
            return true
        }
        return false
    }
    
}
