//
//  WorkPlaceViewController.swift
//  VLCCompany
//
//  Created by macOS on 10/8/18.
//  Copyright © 2018 mac mini. All rights reserved.
//


import UIKit

protocol HashTagListViewControllerDelegate: class {
    
    func didSelectHashTagItems(_ value: [HashTagModel])
}

class HashTagListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var isJobType:Bool = false
    
    weak var delegate: HashTagListViewControllerDelegate?
    var ids:[Int] = [Int]()
    
    var dataSource: [HashTagModel] = [HashTagModel]()
    var dataSourceCopy:[HashTagModel] = [HashTagModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientNavi()
        setupNavi()
        dataSource = [HashTagModel(id: 0, name: "Hung"),
                      HashTagModel(id: 1, name: "Hung1"),
                      HashTagModel(id: 2, name: "Hung2"),
                      HashTagModel(id: 3, name: "Hung3"),
                      HashTagModel(id: 4, name: "Hung4"),
                      HashTagModel(id: 5, name: "Hung5")]
        dataSourceCopy = dataSource
    }
    
    
    func setupNavi() {
        let leftBarItem = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(self.didTapCancel(_:)))
        let rightBarItem = UIBarButtonItem(title: "Xong", style: .plain, target: self, action: #selector(self.didTapDone(_:)))
        self.navigationItem.leftBarButtonItem = leftBarItem
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        
        var temp:[HashTagModel] = [HashTagModel]()
        self.dataSourceCopy.forEach { (item) in
            if item.isSelect == true {
                temp.append(item)
            }
        }
//        if temp.count > 3 {
//            print("Chỉ cho phép chọn tối đa 3 mục")
//            return
//        }
        delegate?.didSelectHashTagItems(temp)
        self.dismiss(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceCopy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let item = dataSourceCopy[indexPath.row]
        cell?.textLabel?.text = item.name
        
        if let id = item.id, ids.contains(id) == true {
            cell?.accessoryType = .checkmark
            item.isSelect = true
        }else {
            item.isSelect = false
            cell?.accessoryType = .none
        }
        cell?.tintColor = UIColor(hex: 0xD72328)
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSourceCopy[indexPath.row]
        item.isSelect = !item.isSelect
        guard let id = item.id else {
            return
        }
        
        if item.isSelect == true {
            ids.append(id)
            tableView.reloadRows(at: [indexPath], with: .none)
        }else {
            for(index,element) in ids.enumerated(){
                if item.id == element {
                    ids.remove(at: index)
                    tableView.reloadRows(at: [indexPath], with: .none)
                    return
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 0 {
            
            let array = dataSource.filter( {
                if let item = $0.name {
                    return item.lowercased().trim().forSorting.contains(searchText.lowercased().trim().forSorting)
                }
                return false
                
            } )
            dataSourceCopy = array
            tableView.reloadData()
        }else {
            dataSourceCopy = dataSource
            tableView.reloadData()
        }
    }
}

