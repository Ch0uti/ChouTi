//
//  NSObject+Observation.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-02-11.
//
//

import Foundation

// NOTE: Be sure to removeObservation before this object is deallocated

// MARK: - Observer
public class Observer: NSObject {
    public typealias ObserverHandler = (object: AnyObject, oldValue: AnyObject, newValue: AnyObject) -> Void
    
    /// Object that is being observed
    public private(set) var object: AnyObject?
    
    /// Pause observation
    public var pauseObservation: Bool = false
    
    var handlerDictionary = [String : ObserverHandler]()
    
    private struct ObservingContext { static var Key = "zhObservingContextKey" }
    
    public func observe(object: AnyObject, forKeyPath keyPath: String, withHandler handler: ObserverHandler) {
        if self.object == nil {
            self.object = object
        } else if self.object !== object {
            print("Error: Observer: \(self) is observing: \(object)")
            return
        }
        
        handlerDictionary[keyPath] = handler
        object.addObserver(self, forKeyPath: keyPath, options: [.Old, .New], context: &ObservingContext.Key)
    }
    
    public func removeObservation(object: AnyObject, forKeyPath keyPath: String) {
        if self.object !== object {
            print("Error: Observer: \(self) is not observing: \(object)")
            return
        }
        
        object.removeObserver(self, forKeyPath: keyPath, context: &ObservingContext.Key)
        handlerDictionary.removeValueForKey(keyPath)
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let object = object where pauseObservation == false else { return }
        guard let keyPath = keyPath else {
            print("Warning: Observer: keyPath is nil")
            return
        }
        
        guard let change = change else {
            print("Warning: Observer: change dictionary is nil")
            return
        }
        
        guard let handler = handlerDictionary[keyPath] else {
            print("Warning: Observer: handler for keyPath: \(keyPath) is nil")
            return
        }
        
        guard let oldValue = change[NSKeyValueChangeOldKey] else {
            print("Warning: Observer: oldValue not found")
            return
        }
        
        guard let newValue = change[NSKeyValueChangeNewKey] else {
            print("Warning: Observer: newValue not found")
            return
        }
        
        handler(object: object, oldValue: oldValue, newValue: newValue)
    }
}

// MARK: - NSObject+Observation
public extension NSObject {
    
    // Add an Observer to NSObject
    private struct ObserverKey { static var Key = "zhh_ObserverKey" }
    
    private var observer: Observer? {
        get {
            if let existingObserver = objc_getAssociatedObject(self, &ObserverKey.Key) as? Observer {
                return existingObserver
            } else {
                let newObserver = Observer()
                objc_setAssociatedObject(self, &ObserverKey.Key, newObserver, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return newObserver
            }
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &ObserverKey.Key, newValue as Observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &ObserverKey.Key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    // MARK: - Public
    /**
     Observe property with keyPath.
     Note: `dynamic` attribute is necessary for Swift classes
     
     - parameter keyPath: keyPath for the property
     - parameter handler: Observer handler
     */
    public func observe(keyPath: String, withHandler handler: Observer.ObserverHandler) {
        guard let observer = observer else {
            print("Error: observer is nil")
            return
        }
        
        observer.observe(self, forKeyPath: keyPath, withHandler: handler)
    }
    
    /**
     Remove the observation for keyPath
     
     - parameter keyPath: keyPath of the observation
     */
    public func removeObservation(forKeyPath keyPath: String) {
        guard let observer = observer else {
            print("Error: observer is nil")
            return
        }
        
        observer.removeObservation(self, forKeyPath: keyPath)
        
        // Clean observer if needed
        if observer.handlerDictionary.isEmpty {
            self.observer = nil
        }
    }
}
