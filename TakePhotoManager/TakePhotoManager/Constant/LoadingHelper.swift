//
//  LoadingHelper.swift
//  VLC
//
//  Created by mac mini on 8/23/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import Foundation
import Foundation
import SVProgressHUD
import MBProgressHUD

let LOADING_HELPER = LoadingHelper.shareIntanse


class LoadingHelper:NSObject {
    static let shareIntanse = LoadingHelper()
    override init() {
        SVProgressHUD.setDefaultMaskType(.black)
    }

    func showProgressHUD(status:String? = nil) {
        if SVProgressHUD.isVisible() == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                SVProgressHUD.show(withStatus: status)
            }
        }
    }

    func dismissProgressHUD() {
        DispatchQueue.global(qos: .userInitiated).async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                SVProgressHUD.dismiss()
            }
        }
    }
}

// MARK: MBProgressHUD
extension LoadingHelper {

    func showProgressHUD(inView view: UIView, text: String = "") {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
            progressHUD.mode = .indeterminate
            progressHUD.label.text = text
        }
    }

    func hideProgressHUD(inView view: UIView) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
    }

}
