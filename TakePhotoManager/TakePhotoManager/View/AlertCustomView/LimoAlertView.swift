//
//  LimoAlertView.swift
//  LimoCab
//
//  Created by  Hoan  vu on 2/28/17.
//  Copyright © 2017 IT Universal Solution. All rights reserved.
//

import UIKit

class LimoAlertView: SCLAlertView {

    
    var alertTitle:String = ""
    var alertMessage:String = ""
   
    
    init(title:String = "THÔNG BÁO" ,message:String) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: AppFont.HelveticaNeue.font(ofSize: 16, weight: .Bold),
            kTextFont: AppFont.HelveticaNeue.font(ofSize: 14, weight: .Regular),
            kButtonFont: AppFont.HelveticaNeue.font(ofSize: 14, weight: .Bold),
            showCloseButton: false,
            showCircularIcon: false,
            buttonsLayout:.horizontal
        )

        super.init(appearance: appearance)
        self.alertTitle = title
//        let messageStr = message.replace(target: "\\n", withString: "\n")
        self.alertMessage = message
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func negativeAction(title:String,action:(() -> ())? = nil) {
        if let block = action {
            
            self.addButton(title,
                           backgroundColor: UIColor.black,
                           textColor: UIColor.white,
                           showTimeout: nil,
                           action: block)
           
        }else {
              self.addButton(title,
                             backgroundColor: UIColor.black,
                             textColor: UIColor.white,
                             showTimeout: nil,
                             action: {})
        }
    }
    
    func positvieAction(title:String,action:@escaping () -> Void) {
        
          self.addButton(title,
                         backgroundColor: AppColor.mainColor,
                         textColor: UIColor.white,
                         showTimeout: nil,
                         action: action)
    }
    
    func show() {
        self.showSuccess(alertTitle, subTitle: alertMessage)
    }
}
