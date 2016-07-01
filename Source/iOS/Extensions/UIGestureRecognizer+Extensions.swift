//
//  UIGestureRecognizer+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-04.
//
//

import UIKit

// MARK: - Add Velocity for UILongPressGestureRecognizer
public extension UILongPressGestureRecognizer {
    private struct zhLastLocationKey {
        static var Key = "zhLastLocationKey"
    }
    
    private var lastLocation: CGPoint? {
        get { return (objc_getAssociatedObject(self, &zhLastLocationKey.Key) as? NSValue)?.CGPointValue() }
        set { objc_setAssociatedObject(self, &zhLastLocationKey.Key, (newValue != nil ? NSValue(CGPoint: newValue!) : nil), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private struct zhLastUpdatedTimeIntervalSince1970Key {
        static var Key = "zhLastUpdatedTimeIntervalSince1970Key"
    }
    
    private var lastUpdatedTimeIntervalSince1970: NSTimeInterval? {
        get {
            return objc_getAssociatedObject(self, &zhLastUpdatedTimeIntervalSince1970Key.Key) as? NSTimeInterval
        }
        set {
            objc_setAssociatedObject(self, &zhLastUpdatedTimeIntervalSince1970Key.Key, newValue as NSTimeInterval?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private struct zhVelocityKey {
        static var Key = "zhVelocityKey"
    }
    
    private var _velocity: CGPoint? {
        get { return (objc_getAssociatedObject(self, &zhVelocityKey.Key) as? NSValue)?.CGPointValue() }
        set { objc_setAssociatedObject(self, &zhVelocityKey.Key, (newValue != nil ? NSValue(CGPoint: newValue!) : nil), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public func setupForDetectingVelocity() {
        self.addTarget(self, action: #selector(UILongPressGestureRecognizer.longPressed(_:)))
    }
    
    func longPressed(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .Began:
            lastLocation = gesture.locationInView(view)
            lastUpdatedTimeIntervalSince1970 = NSDate().timeIntervalSince1970
            
        case .Changed:
            guard let lastUpdatedTimeIntervalSince1970 = lastUpdatedTimeIntervalSince1970 else {
                NSLog("Error: \(self): lastUpdatedTimeIntervalSince1970 is nil")
                break
            }
            
            guard let lastLocation = lastLocation else {
                NSLog("Error: \(self): lastLocation is nil")
                break
            }
            
            let currentLocation = gesture.locationInView(view)
            let currentTimeIntervalSince1970 = NSDate().timeIntervalSince1970
            
            let locationOffset = CGPoint(x: currentLocation.x - lastLocation.x, y: currentLocation.y - lastLocation.y)
            let timeInterval = currentTimeIntervalSince1970 - lastUpdatedTimeIntervalSince1970
            
            _velocity = CGPoint(x: locationOffset.x / CGFloat(timeInterval), y: locationOffset.y / CGFloat(timeInterval))
            
            self.lastLocation = gesture.locationInView(view)
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
            return CGPointZero
        }
    }
}
