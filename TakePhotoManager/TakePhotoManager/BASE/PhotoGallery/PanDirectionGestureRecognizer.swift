//
//  PanDirectionGestureRecognizer.swift
//  PhotoGallery
//
//  Created by Vuong Nguyen on 2/22/18.
//  Copyright © 2018 Vuong Nguyen. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

enum PanDirection {
    case horizontal
    case vertical
}

class PanDirectionGestureRecognizer: UIPanGestureRecognizer {
    let direction: PanDirection

    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        if state == .began {
            let vel = velocity(in: view)
            switch direction {
            case .horizontal where abs(vel.y) > abs(vel.x):
                state = .cancelled
            case .vertical where abs(vel.x) > abs(vel.y):
                state = .cancelled
            default:
                break
            }
        }
    }
}
