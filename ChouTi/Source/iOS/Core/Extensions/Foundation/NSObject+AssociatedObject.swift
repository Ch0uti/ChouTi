//
//  NSObject+AssociatedObject.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import Foundation

//Ref: [Associated Objects](http://nshipster.com/associated-objects/)
//Ref: [objc_setAssociatedObject with nil to remove - is policy is ignored](http://stackoverflow.com/questions/19920591/objc-setassociatedobject-with-nil-to-remove-is-policy-checked)

public extension NSObject {
    private struct zhAssociateObjectKey {
        static var Key = "zhAssociateObjectKey"
    }
    
    /// Strong referenced associated object
    public var associatedObject: Any? {
        get { return objc_getAssociatedObject(self, &zhAssociateObjectKey.Key) }
        set { objc_setAssociatedObject(self, &zhAssociateObjectKey.Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /**
     set an associated object for key pointer
     Example usage:
     private struct SomeKey {
     static var Key = "RandomKey"
     }
     
     setAssociatedObejct(someObject, forKeyPointer: &SomeKey.Key)
     
     - parameter object:  an object to be associated
     - parameter pointer: pointer
     - parameter associationPolicy: associationPolicy, default to .OBJC_ASSOCIATION_RETAIN_NONATOMIC (strong reference). Use .OBJC_ASSOCIATION_ASSIGN for weak reference.
     
     - returns: old associated object if existed
     */
	@discardableResult
    public func setAssociatedObejct(_ object: Any, forKeyPointer pointer: UnsafeRawPointer? = nil, associationPolicy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> Any? {
        if let pointer = pointer {
            let currentAssociatedObject = getAssociatedObject(forKeyPointer: pointer)
            objc_setAssociatedObject(self, pointer, object, associationPolicy)
            return currentAssociatedObject
        } else {
            let currentAssociatedObject = associatedObject
            associatedObject = object
            return currentAssociatedObject
        }
    }
    
    public func getAssociatedObject(forKeyPointer pointer: UnsafeRawPointer? = nil) -> Any? {
        if let pointer = pointer {
            return objc_getAssociatedObject(self, pointer)
        } else {
            return associatedObject
        }
    }
	
	@discardableResult
    public func clearAssociatedObject(forKeyPointer pointer: UnsafeRawPointer? = nil) -> Any? {
        if let pointer = pointer {
            let object = getAssociatedObject(forKeyPointer: pointer)
            // policy is ignored if new value is nil, thus .OBJC_ASSOCIATION_RETAIN_NONATOMIC doesn't
            objc_setAssociatedObject(self, pointer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return object
        } else {
            let object = associatedObject
            associatedObject = nil
            return object
        }
    }
}
