//
//  FloatingButtonWindow.swift
//  Foodomia
//
//  Created by HoanVu on 7/16/19.
//  Copyright © 2019 dinosoftlabs. All rights reserved.
//

import Foundation
import UIKit

class FloatingButtonWindow: UIWindow {
    var button: MFBadgeButton?
    
    static let shared: FloatingButtonWindow = FloatingButtonWindow()
    let windowCurrent = UIApplication.shared.keyWindow!
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addFloatingButton(numberBadge: String) {
        if self.button == nil {
            let button: MFBadgeButton = MFBadgeButton(type: .custom)
            let image = UIImage(named: "ic-cart")?.withRenderingMode(.alwaysTemplate)
            button.tintColor = .white
            button.setImage(image, for: .normal)
            button.backgroundColor = UIColor.init(hex: 0x00885A)
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowRadius = 3
            button.layer.shadowOpacity = 0.12
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.cornerRadius = 22.0
            button.sizeToFit()
            let buttonSize = CGSize(width: 60, height: 60)
            let rect = UIScreen.main.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
            button.frame = CGRect(origin: CGPoint(x: rect.maxX - 15, y: rect.minY + topSafeAreaConStraint!), size: CGSize(width: 60, height: 60))
            // button.cornerRadius = 30 -> Will destroy your shadows, however you can still find workarounds for rounded shadow.
            button.autoresizingMask = []
            windowCurrent.addSubview(button)
            self.button = button
            let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire(panner:)))
            self.button?.addGestureRecognizer(panner)
            self.button?.addTarget(self, action: #selector(floatingButtonPressed), for: .touchUpInside)
            snapButtonToSocket()
        }
        
        self.button?.badge = numberBadge
        
        UIView.animate(withDuration: 1.0, animations: {[unowned self]() -> Void in
            let endingColor = UIColor.init(hex: 0x00885A)
            self.button?.backgroundColor = endingColor
            
            // ROTATE ANIMATION
            let rotate = CGAffineTransform(rotationAngle: 0)
            //            button.transform = rotate
            
            // SCALE ANIMATION
            let scale = CGAffineTransform(scaleX: 2.0, y: 2.0)
            //circle.transform = scale
            
            // ROTATE AND SCALE ANIMATION
            self.button?.transform = rotate.concatenating(scale)
            
            // SHAKE ANIMATION
            self.button!.wiggle()
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                let scaleTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.button?.transform = rotate.concatenating(scaleTransform)
            })
        })
    }
    
    @objc func floatingButtonPressed(){
        print("Floating button tapped")
        
        
    }
    
    func removeFloatingButton() {
        self.button?.removeFromSuperview()
        self.button = nil
    }
    
    @objc fileprivate func panDidFire(panner: UIPanGestureRecognizer) {
        guard let floatingButton = self.button else {return}
        let offset = panner.translation(in: windowCurrent)
        panner.setTranslation(CGPoint.zero, in: windowCurrent)
        var center = floatingButton.center
        center.x += offset.x
        center.y += offset.y
        floatingButton.center = center
        
        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.snapButtonToSocket()
            }
        }
    }
    
    fileprivate func snapButtonToSocket() {
        guard let floatingButton = self.button else {return}
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let center = floatingButton.center
        for socket in sockets {
            let distance = hypot(center.x - socket.x, center.y - socket.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = socket
            }
        }
        floatingButton.center = bestSocket
    }
    
    fileprivate var sockets: [CGPoint] {
        let buttonSize = self.button?.bounds.size ?? CGSize(width: 0, height: 0)
        let rect = windowCurrent.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        let sockets: [CGPoint] = [
            CGPoint(x: rect.minX + 15, y: rect.minY + topSafeAreaConStraint!),
            CGPoint(x: rect.minX + 15, y: rect.maxY - 50),
            CGPoint(x: rect.maxX - 15, y: rect.minY + topSafeAreaConStraint!),
            CGPoint(x: rect.maxX - 15, y: rect.maxY - 50)
        ]
        return sockets
    }
    
    // Custom socket position to hold Y position and snap to horizontal edges.
    // You can snap to any coordinate on screen by setting custom socket positions.
    fileprivate var horizontalSockets: [CGPoint] {
        guard let floatingButton = self.button else {return []}
        let buttonSize = floatingButton.bounds.size
        let rect = windowCurrent.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        let y = min(rect.maxY - 50, max(rect.minY + 30, floatingButton.frame.minY + buttonSize.height / 2))
        let sockets: [CGPoint] = [
            CGPoint(x: rect.minX + 15, y: y),
            CGPoint(x: rect.maxX - 15, y: y)
        ]
        return sockets
    }
    
    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = button else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }
}

