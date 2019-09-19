//
//  ListGroupViewController.swift
//  TakePhotoManager
//
//  Created by HoanVu on 9/19/19.
//  Copyright © 2019 DangHung. All rights reserved.
//

import UIKit

class ListGroupViewController: BaseViewController {
    @IBOutlet weak var tableView: MyTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTableView()
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ListGroupTableViewCell.nib, forCellReuseIdentifier: ListGroupTableViewCell.reuseIdentifier)
        
    }

}

extension ListGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ListGroupTableViewCell.reuseIdentifier, for: indexPath) as? ListGroupTableViewCell {
            cell.numberUser = indexPath.row + 2
            print(indexPath.row)
            return cell
            
        }
        
        return UITableViewCell()
    }
}
