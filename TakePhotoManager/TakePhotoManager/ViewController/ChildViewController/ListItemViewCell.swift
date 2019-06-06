//
//  ListItemViewCell.swift
//  InfoSoft
//
//  Created by macOS on 11/30/18.
//  Copyright © 2018 Thach tran. All rights reserved.
//

import UIKit

class ListItemViewCell: BaseTableViewCell {

  
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    
    var itemObj:CalendarModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func click_detail(_ sender: Any) {
        
    }
    func bindingData(item:CalendarModel) {
        
        itemObj = item
        imgType.image = (item.loai == ";0;" ? UIImage(named: "ic_meeting") : UIImage(named: "ic_job"))
        lbTitle.text = item.name
        if let begin = item.batdau?.convertStringToDate()?.stringWithFormat(format: DD_MM_YYYY_HH_MM), let end = item.kethuc?.convertStringToDate()?.stringWithFormat(format: DD_MM_YYYY_HH_MM) {
            lbDate.text = (begin + " đến " + end)
        }
    }
}
    
