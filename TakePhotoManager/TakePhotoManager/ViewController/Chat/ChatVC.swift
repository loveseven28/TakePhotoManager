//
//  ChatVC.swift
//  AppChat
//
//  Created by dang hung on 10/7/18.
//  Copyright © 2018 dang hung. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    @IBOutlet weak var sendMessageView: SendMessageView!
    @IBOutlet weak var tableView: UITableView!
    var messageData: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        sendMessageView.delegate = self
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }

    private func initTableView() {
        tableView.register(ChatLeftTVCell.nib, forCellReuseIdentifier: ChatLeftTVCell.reuseIdentifier)
        tableView.register(ChatRightTVCell.nib, forCellReuseIdentifier: ChatRightTVCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        scrollToBottom()

    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
    }
    
    @IBAction func listGroupDidTaped(_ sender: Any) {
        
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 1 {
            if let leftCell = tableView.dequeueReusableCell(withIdentifier: ChatLeftTVCell.reuseIdentifier, for: indexPath) as? ChatLeftTVCell {
                leftCell.selectionStyle = .none
                leftCell.lbMessage.text = messageData[indexPath.row]
                return leftCell
            }
        } else {
            if let rightCell = tableView.dequeueReusableCell(withIdentifier: ChatRightTVCell.reuseIdentifier, for: indexPath) as? ChatRightTVCell {
                rightCell.selectionStyle = .none
                rightCell.lbMessage.text = messageData[indexPath.row]

                return rightCell
            }
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

extension ChatVC: SendMessageViewDelegate {
    
    func sendMessageView(_ sendMessageView: SendMessageView, didSend message: String, sendButton: UIButton) {
        
        messageData.insert(message, at: 0)
        
        
        tableView.beginUpdates()
        
        let indexPath:IndexPath = IndexPath(row:(self.messageData.count - 1), section:0)
        
        tableView.insertRows(at: [indexPath], with: .top)
        print(indexPath.row, "-----------------..........>>>>>>>>>>>>")
        
        tableView.endUpdates()
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        tableView.reloadData()
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets.zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
//        var indexPath:IndexPath = IndexPath(item: 0, section: 0)
//        if messageData.count > 0 {
//            indexPath = IndexPath(row:(self.messageData.count - 1), section:0)
//        }
//        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

}
