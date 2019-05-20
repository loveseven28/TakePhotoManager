//
//  TagView.swift
//  Wecare247
//
//  Created by macOS on 9/7/18.
//  Copyright © 2018 Mac Mini. All rights reserved.
//

import UIKit

protocol TagViewDelegate: class {
    func tagView(tagView: TagView, didDelete item: Any)
}


class HashTagModel {
    
    var id:Int?
    var name:String?
    var isSelect:Bool = false
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

@IBDesignable
class TagView: ViewBase , TagViewCellDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbPlaceHolder: UITextField!

    
    weak var delegate: TagViewDelegate?
    var heightConstraint:NSLayoutConstraint?
    
    lazy var vc = HashTagListViewController(nibName: "HashTagListViewController", bundle: nil)
    
    
    
    override func awakeFromNib() {
        collectionView.register(UINib.init(nibName: "TagViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = UIView(frame: CGRect.zero)
        if let tagLayout = collectionView.collectionViewLayout as? TagItemLayout {
            tagLayout.delegate = self
        }
        getAllConstraint()
    }
    
    
    
    func getAllConstraint() {
        
         self.constraints.forEach({ (contraint) in
            if contraint.firstAttribute.toString() == "height" {
                heightConstraint = contraint
                return
            }
        })
    }
    
    @IBInspectable var title:String = "" {
        didSet {
           vc.title = title
        }
    }
    
    @IBInspectable var isJobType:Bool = false {
        didSet {
            vc.isJobType = isJobType
        }
    }
    
    @IBInspectable var placeHolder:String = "" {
        didSet {
            lbPlaceHolder.placeholder = placeHolder
        }
    }
    
    
    var ids:[Int] {
        var temp = [Int]()
        items.forEach { (item) in
            if let id = item.id {
                temp.append(id)
            }
        }
        return temp
    }
    
    var items:[HashTagModel] = [HashTagModel]() {
        didSet {
            self.lbPlaceHolder.isHidden = (items.count > 0)
            collectionView.reloadData()
        }
    }
    
    func removeTokenAtIndex(index: Int) {
        delegate?.tagView(tagView: self, didDelete: items[index])
        items.remove(at: index)
        collectionView.reloadData()
    }
  
    @IBAction func click_listHashTag(_ sender:UIButton) {
        vc.delegate = self
        vc.ids = self.ids
        UIWindow.topViewController()?.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
}
extension TagView : TagItemLayoutDelegate,HashTagListViewControllerDelegate {
    
    func didSelectHashTagItems(_ value: [HashTagModel]) {
        self.items = value
    }
    
    func textForIndexPath(index: IndexPath) -> String? {
        let item = items[index.row]
        return item.name
    }
    
    func prepareAttributeFrameDone() {
        heightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
}

extension TagView : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagViewCell
        cell.lbText.text = items[indexPath.row].name
        cell.delegate = self
        return cell
    }
}


extension NSLayoutConstraint.Attribute {
    
    func toString() -> String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            fatalError()
        }
    }
}
