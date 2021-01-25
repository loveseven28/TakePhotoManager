//
//  CATransform3D+Ext.swift
//  SBase
//
//  Created by Thanh Sang on 6/3/20.
//  Copyright © 2020 FLYG. All rights reserved.
//


import UIKit

private let defaultPerspective: CGFloat = -1.0 / 500


struct Degree {

    let value: Double

    var radians: CGFloat {
        return CGFloat(value * Double.pi / 180.0)
    }
}

// MARK - Negative Degrees

prefix func -(degree: Degree) -> Degree {
    return Degree(value: -1 * degree.value)
}

// MARK: - Double

extension Double {

    var degrees: Degree {
        return Degree(value: self)
    }
}

extension CATransform3D {

    enum Axis { case x, y, z }

    static var identity: CATransform3D {
        return CATransform3DIdentity
    }
    
    // MARK: - Rotate and Translation

    func rotate(_ axis: Axis, by degree: Degree) -> CATransform3D {
        let radians = degree.radians
        switch axis {
        case .x:
            return CATransform3DRotate(self, radians, 1, 0, 0)
        case .y:
            return CATransform3DRotate(self, radians, 0, 1, 0)
        case .z:
            return CATransform3DRotate(self, radians, 0, 0, 1)
        }
    }

    func scale(_ axis: Axis, by scale: CGFloat) -> CATransform3D {
        switch axis {
        case .x:
            return CATransform3DScale(self, scale, 1, 1)
        case .y:
            return CATransform3DScale(self, 1, scale, 1)
        case .z:
            return CATransform3DScale(self, 1, 1, scale)
        }
    }

    func translate(_ axis: Axis, by value: CGFloat) -> CATransform3D {
        switch axis {
        case .x:
            return CATransform3DTranslate(self, value, 0, 0)
        case .y:
            return CATransform3DTranslate(self, 0, value, 0)
        case .z:
            return CATransform3DTranslate(self, 0, 0, value)
        }
    }

    func perspective(_ m34: CGFloat = defaultPerspective) -> CATransform3D {
        var transform = self
        transform.m34 = m34
        return transform
    }
}
