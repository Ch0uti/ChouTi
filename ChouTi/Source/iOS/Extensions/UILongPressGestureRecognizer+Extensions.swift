//
//  Created by Honghao Zhang on 12/04/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

// MARK: - Add Velocity for UILongPressGestureRecognizer
public extension UILongPressGestureRecognizer {
    private enum zhLastLocationKey {
        static var Key = "zhLastLocationKey"
    }

    private var lastLocation: CGPoint? {
        get { return (objc_getAssociatedObject(self, &zhLastLocationKey.Key) as? NSValue)?.cgPointValue }
        set { objc_setAssociatedObject(self, &zhLastLocationKey.Key, (newValue != nil ? NSValue(cgPoint: newValue!) : nil), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private enum zhLastUpdatedTimeIntervalSince1970Key {
        static var Key = "zhLastUpdatedTimeIntervalSince1970Key"
    }

    private var lastUpdatedTimeIntervalSince1970: TimeInterval? {
        get {
            return objc_getAssociatedObject(self, &zhLastUpdatedTimeIntervalSince1970Key.Key) as? TimeInterval
        }
        set {
            objc_setAssociatedObject(self, &zhLastUpdatedTimeIntervalSince1970Key.Key, newValue as TimeInterval?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private enum zhVelocityKey {
        static var Key = "zhVelocityKey"
    }

    private var _velocity: CGPoint? {
        get { return (objc_getAssociatedObject(self, &zhVelocityKey.Key) as? NSValue)?.cgPointValue }
        set { objc_setAssociatedObject(self, &zhVelocityKey.Key, (newValue != nil ? NSValue(cgPoint: newValue!) : nil), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public func setupForDetectingVelocity() {
        self.addTarget(self, action: #selector(longPressed(_:)))
    }

    @objc
    private dynamic func longPressed(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            lastLocation = gesture.location(in: view)
            lastUpdatedTimeIntervalSince1970 = Date().timeIntervalSince1970

        case .changed:
            guard let lastUpdatedTimeIntervalSince1970 = lastUpdatedTimeIntervalSince1970 else {
                NSLog("Error: \(self): lastUpdatedTimeIntervalSince1970 is nil")
                break
            }

            guard let lastLocation = lastLocation else {
                NSLog("Error: \(self): lastLocation is nil")
                break
            }

            let currentLocation = gesture.location(in: view)
            let currentTimeIntervalSince1970 = Date().timeIntervalSince1970

            let locationOffset = CGPoint(x: currentLocation.x - lastLocation.x, y: currentLocation.y - lastLocation.y)
            let timeInterval = currentTimeIntervalSince1970 - lastUpdatedTimeIntervalSince1970

            _velocity = CGPoint(x: locationOffset.x / CGFloat(timeInterval), y: locationOffset.y / CGFloat(timeInterval))

            self.lastLocation = gesture.location(in: view)
            self.lastUpdatedTimeIntervalSince1970 = currentTimeIntervalSince1970
        default:
            lastLocation = nil
            lastUpdatedTimeIntervalSince1970 = nil
        }
    }

    public func velocityInAttachedView() -> CGPoint {
        if let _velocity = _velocity {
            return _velocity
        } else {
            return CGPoint.zero
        }
    }
}
