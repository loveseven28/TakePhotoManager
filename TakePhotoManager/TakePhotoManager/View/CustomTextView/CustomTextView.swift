//
//  CustomTextView.swift
//  TakePhotoManager
//
//  Created by dang hung on 11/16/20.
//  Copyright © 2020 DangHung. All rights reserved.
//

import UIKit
import Foundation

/// CustomTextViewDelegate
protocol CustomTextViewDelegate: class {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    func textViewDidBeginEditing(_ textView: UITextView)
    func textViewDidChange(_ textView: UITextView)
    func textViewDidEndEditing(_ textView: UITextView)
}

extension CustomTextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { return true }
    func textViewDidBeginEditing(_ textView: UITextView) {}
    func textViewDidChange(_ textView: UITextView) {}
    func textViewDidEndEditing(_ textView: UITextView) {}
}

/// CustomTextView support auto height UITextView and bottom line
class CustomTextView: ViewBase {
    @IBOutlet weak var textView: UITextViewX!
    @IBOutlet weak var labelBottom: UILabel!
    
    // MARK: - Properties
    @IBInspectable
    var lineColor: UIColor = .lightGray
    
    @IBInspectable
    var selectedLineColor: UIColor = .systemBlue
    
    weak var myDelegate: CustomTextViewDelegate?
    
    internal lazy var textViewHeightConstraint: NSLayoutConstraint = {
      let constraint = self.textView.heightAnchor.constraint(equalToConstant: 0)
      constraint.priority = .defaultHigh
      return constraint
    }()

    public override func layoutSubviews() {
      super.layoutSubviews()
      // Assuming there is width constraint setup on the textView.
      let targetSize = CGSize(width: textView.frame.width, height: CGFloat(MAXFLOAT))
      textViewHeightConstraint.constant = textView.sizeThatFits(targetSize).height
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textView.delegate = self
    }
}

//MARK: UITextViewDelegate
extension CustomTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        labelBottom.backgroundColor = selectedLineColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        labelBottom.backgroundColor = lineColor
        textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.layoutSubviews()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return myDelegate!.textView(textView, shouldChangeTextIn: range, replacementText: text)
    }
}
