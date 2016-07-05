//
//  StructWrapper.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import Foundation

// StructWrapper is a generic container for Swift struct
// This is useful where NSObject is reqired

// Sample Usage:

// struct -> object
// let object = <#structValue#>.map { StructWrapper<<#StructType#>>($0) }
// or
// let object = StructWrapper<<#StructType#>>(<#structValue#>)

// object - > struct
// let theStruct = (object as? StructWrapper<<#StructType#>>).map { $0.structValue }
// or
// let theStruct = (object as? StructWrapper<<#StructType#>>)?.structValue

public final class StructWrapper<StructType>: NSObject, NSCopying {
	public let structValue: StructType
	
	public init(_ structValue: StructType) { self.structValue = structValue }
	
	public func copyWithZone(zone: NSZone) -> AnyObject {
		return self.dynamicType.init(structValue)
	}
}

extension StructWrapper where StructType: NSCopying {
	public func copyWithZone(zone: NSZone) -> AnyObject {
		return self.dynamicType.init(structValue.copyWithZone(zone) as! StructType)
	}
}

extension StructWrapper {
	public static func structFromObject(object: AnyObject?) -> StructType? {
		if object == nil {
			return nil
		}
		
		return (object as? StructWrapper<StructType>)?.structValue
	}
	
	public static func objectFromStruct(aStruct: StructType?) -> StructWrapper<StructType>? {
		if let aStruct = aStruct {
			return StructWrapper<StructType>(aStruct)
		} else {
			return nil
		}
	}
}
