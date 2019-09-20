//
//  OEUHeaderView.swift
//  oeu
//
//  Created by macOS on 5/21/19.
//  Copyright © 2019 Thach tran. All rights reserved.
//

import UIKit

class OEUHeaderView: ViewBase {

    override func awakeFromNib() {
        super.awakeFromNib()
        let shapeLayer = CAShapeLayer(layer: self.layer)
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height / 2))
        path.addQuadCurve(to: CGPoint(x: UIScreen.main.bounds.width, y: self.bounds.height / 2),
                          controlPoint: CGPoint(x: UIScreen.main.bounds.width / 2, y: self.bounds.height))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
        path.close()
        shapeLayer.path = path.cgPath
        shapeLayer.frame = CGRect.init(origin: self.bounds.origin, size: CGSize(width: UIScreen.main.bounds.width, height: self.frame.height))
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
        
    }
}
