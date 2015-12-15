//
//  NSObject+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import Foundation

public extension NSObject {
	private struct zhAssociateObjectKey {
		static var Key = "zhAssociateObjectKey"
	}
	
	public var associatedObject: AnyObject? {
		get { return objc_getAssociatedObject(self, &zhAssociateObjectKey.Key) }
		set { objc_setAssociatedObject(self, &zhAssociateObjectKey.Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	
	public func setAssociatedObejct(object: AnyObject, forKeyPointer pointer: UnsafePointer<String> = nil) -> AnyObject? {
		if pointer == nil {
			let currentAssociatedObject = associatedObject
			associatedObject = object
			return currentAssociatedObject
		} else {
			let currentAssociatedObject = getAssociatedObject(forKeyPointer: pointer)
			objc_setAssociatedObject(self, pointer, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return currentAssociatedObject
		}
	}
	
	public func getAssociatedObject(forKeyPointer pointer: UnsafePointer<String> = nil) -> AnyObject? {
		if pointer == nil {
			return associatedObject
		} else {
			return objc_getAssociatedObject(self, pointer)
		}
	}
	
	public func clearAssociatedObject(forKeyPointer pointer: UnsafePointer<String> = nil) -> AnyObject? {
		if pointer == nil {
			let object = associatedObject
			associatedObject = nil
			return object
		} else {
			let object = getAssociatedObject(forKeyPointer: pointer)
			objc_setAssociatedObject(self, pointer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return object
		}
	}
}
