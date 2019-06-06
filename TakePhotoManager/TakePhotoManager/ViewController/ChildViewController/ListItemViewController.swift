//
//  ListItemViewController.swift
//  InfoSoft
//
//  Created by macOS on 11/30/18.
//  Copyright © 2018 Thach tran. All rights reserved.
//

import UIKit

class CalendarModel {
    
    var id:String?
    var name:String?
    var batdau:String?
    var kethuc:String?
    var loai:String?
    
    init(json:[String:Any]) {
        
        id = json["ID"] as? String
        name = json["Name"] as? String
        batdau = json["BatDau"] as? String
        kethuc = json["KetThuc"] as? String
        loai = json["Loai"] as? String
    }
}

class ListItemViewController: BaseViewController , UIGestureRecognizerDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: MyTableView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    let searchBar = UISearchBar()
    var isSearch:Bool = false
    var searchKeyword:String?
    var trangthai:String? {
        didSet {
            tableView.page = -1
            list = []
            listShiftMornings = []
            getList()
        }
    }
    
    let fullView: CGFloat = 0
    var partialView: CGFloat = 0
    
   
    var listShiftMornings:[CalendarModel] = [CalendarModel]()
    var list:[CalendarModel] = [CalendarModel]()
    var topSafeArea: CGFloat = 0.0
    var filterDate:String? {
        didSet {
            let date = filterDate?.convertStringToDate(format: YYYY_MM_DD)?.toString()
            self.lbDate.text = date
            
            tableView.page = -1
            list = []
            listShiftMornings = []
            getList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        self.headerView.layer.masksToBounds = false;
        self.headerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.headerView.layer.shadowOffset = CGSize(width: -5, height: -5)
        self.headerView.layer.shadowOpacity = 0.5;
        
        tableView.register(ListItemViewCell.nib, forCellReuseIdentifier: ListItemViewCell.reuseIdentifier)
        
        self.tableView.estimatedRowHeight = UITableView.automaticDimension

        if isSearch == true {
            self.addSearchBar(searchBar: searchBar)
            self.headerView.isHidden = true
        }else {
            let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGesture))
            gesture.delegate = self
            view.addGestureRecognizer(gesture)
            self.filterDate = Date().stringWithFormat(format: YYYY_MM_DD)
        }
    }
    
    
    func initView() {
        var calendarHeight:CGFloat = 0
        self.view.frame.y = 0
        if let vc = self.parent as? ChildViewController {
            calendarHeight = vc.heightCalendarConstraint.constant
        }
        if let window = UIApplication.shared.keyWindow {
            var top: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                top = window.safeAreaInsets.top
            } else {
                top = topLayoutGuide.length
            }
            
            self.topSafeArea = top + 44
            partialView = calendarHeight + (top == 20.0 ? 10 : top)
        }
        
        UIView.animate(withDuration: 0.2) {  [weak self] in
            guard let `self` = self else { return }
            let frame = self.view.frame
            print(frame)
            let y = self.partialView
            self.view.frame = CGRect(x: 0, y: y, width : frame.width, height: frame.height)
        }
    }
    
    func updateLocationView(heightConstraint: CGFloat) {
        partialView = heightConstraint
        UIView.animate(withDuration: 0.2) {  [weak self] in
            guard let `self` = self else { return }
            let y = self.partialView
            self.view.frame = CGRect(x: 0, y: y, width : self.view.frame.width, height: self.view.frame.height)
        }
    }
   
    override func hiddenKeyboard() {
        super.hiddenKeyboard()
        self.searchBar.endEditing(true)
    }
    
    func getList() {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        listShiftMornings = []
        list = []
        self.searchBar.endEditing(true)
        self.searchKeyword = searchBar.text
        getList()
    }

}

extension ListItemViewController {
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let y = self.view.frame.minY
        
        if recognizer.state == .began || recognizer.state == .changed {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }

        if recognizer.state == .ended {

            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            duration = duration > 1.3 ? 1 : duration

            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.topSafeArea, width: self.view.frame.width, height: self.view.frame.height)
                }
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.tableView.isScrollEnabled = true
                }
            })
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        return false
    }

}

extension ListItemViewController: UITableViewDataSource, UITableViewDelegate, MyTableViewDelegate {
    func handleRefreshControl() {
        listShiftMornings = []
        list = []
        self.tableView.page = -1
        self.getList()
    }
    
    func isHaveData() -> Bool {
        if list.count > 0 || listShiftMornings.count > 0 {
            return true
        }
        return false
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if list.count > 0 || listShiftMornings.count > 0 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        header.backgroundColor = UIColor.init(hex: 0xF7F7F7)
        let headerTitle = UILabel(frame: CGRect(x: 10, y: header.center.y - 7, width: 120, height: 15))
        headerTitle.text = (section == 0 ? "Sáng": "Chiều")
        headerTitle.textColor = UIColor.black
        headerTitle.font = AppFont.HelveticaNeue.font(ofSize: 15, weight: .Regular)
        header.addSubview(headerTitle)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listShiftMornings.count
        }
        return list.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListItemViewCell.reuseIdentifier, for: indexPath) as? ListItemViewCell {
            if indexPath.section == 0 {
                let item = listShiftMornings[indexPath.row]
                cell.bindingData(item: item)
            }else {
                let item = list[indexPath.row]
                cell.bindingData(item: item)
            }
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isAtBottom , self.tableView.allowLoadMore() {
            self.getList()
        }
    }
}

