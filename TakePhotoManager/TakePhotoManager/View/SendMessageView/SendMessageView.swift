//
//  SendMessageView.swift
//  AppChat
//
//  Created by dang hung on 10/7/18.
//  Copyright © 2018 dang hung. All rights reserved.
//

import UIKit
import GrowingTextView

protocol SendMessageViewDelegate: class {
    func sendMessageView(_ sendMessageView: SendMessageView, didSend message: String, sendButton: UIButton)
}
class SendMessageView: ViewBase {
    weak var delegate: SendMessageViewDelegate?
    @IBOutlet weak var inputTextView: GrowingTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextView.contentInset.left = 8
        inputTextView.contentInset.right = 8
        inputTextView.delegate = self
        
    }
    
    @IBAction func attachButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        if inputTextView.text != "What are doing?", inputTextView.text != "" {
            delegate?.sendMessageView(self, didSend: inputTextView.text, sendButton: sender)
            self.inputTextView.text = ""
        }
    }
}

extension SendMessageView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
}

extension SendMessageView: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
