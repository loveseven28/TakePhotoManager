//
//  MyTableView.swift
//  SangMobile
//
//  Created by Mac Mini on 7/12/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit


protocol MyTableViewDelegate {
    
    func isHaveData() -> Bool
    
    func handleRefreshControl()
}

@IBDesignable
class MyTableView: UITableView {
    
    
    var emptyView:EmptyView = EmptyView()
    var page:Int = 0 {
        didSet {
            isLoadingMore = true
        }
    }
    
    var totalPage = 0
    var isLoadingMore:Bool = false
    var hasMoreRows:Bool = false
    
    var myDelegate:MyTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.tableFooterView = UIView()
        self.estimatedSectionHeaderHeight = 0
        self.sectionHeaderHeight = UITableView.automaticDimension
        
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 100
        
        
        if let d = self.viewController as? MyTableViewDelegate {
            self.myDelegate = d
        }
        setUpUI()
    }
    
    override func reloadData() {
        isLoadingMore = false
        
        if myDelegate?.isHaveData() == false {
            self.separatorStyle = .none
            emptyView.frame = CGRect(x: self.backgroundView?.center.x ?? 0, y: self.backgroundView?.center.y ?? 0, width: 280, height: 200)
            self.backgroundView = emptyView
            
        }else {
//            self.separatorStyle = .singleLine
            emptyView.removeFromSuperview()
            self.backgroundView =  nil
        }
        
        if hasMoreRows == true {
            let footerView = LoadMoreView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
            footerView.backgroundColor = self.backgroundColor
            tableFooterView = footerView
        }else {
            tableFooterView = nil
        }
        
        super.reloadData()
    }
    
    func allowLoadMore() -> Bool {
        if isLoadingMore == false, page < totalPage {
            return true
        }
        return false
    }
    
    func setUpUI() {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControl.Event.valueChanged)
        
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = AppColor.mainColor
        self.refreshControl = refreshControl
    }
    
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        self.page = 0
        self.totalPage = 0
        refreshControl.beginRefreshing()
        myDelegate?.handleRefreshControl()
    }
}

extension UITableView {
    
    func resizeHeaderView() {
        if let headerView = self.tableHeaderView {
            
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.tableHeaderView?.layoutIfNeeded()
            self.tableHeaderView = headerView
        }
    }
}
