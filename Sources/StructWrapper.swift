// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

// StructWrapper is a generic container for Swift struct/enum
// This is useful where NSObject is reqired

// Sample Usage:
//
// struct -> object
// let object = <#structValue#>.map { StructWrapper<<#StructType#>>($0) }
// or
// let object = StructWrapper<<#StructType#>>(<#structValue#>)
//
// object -> struct
// let theStruct = (object as? StructWrapper<<#StructType#>>).map { $0.structValue }
// or
// let theStruct = (object as? StructWrapper<<#StructType#>>)?.structValue

public final class StructWrapper<StructType>: NSObject, NSCopying {
  public let structValue: StructType

  public init(_ structValue: StructType) { self.structValue = structValue }

  public func copy(with _: NSZone?) -> Any {
    return type(of: self).init(structValue)
  }
}

public extension StructWrapper where StructType: NSCopying {
  func copyWithZone(_ zone: NSZone?) -> Any {
    return type(of: self).init(structValue.copy(with: zone) as! StructType)
  }
}

public extension StructWrapper {
  static func structFromObject(_ object: Any?) -> StructType? {
    if object == nil {
      return nil
    }

    return (object as? StructWrapper<StructType>)?.structValue
  }

  static func objectFromStruct(_ aStruct: StructType?) -> StructWrapper<StructType>? {
    if let aStruct = aStruct {
      return StructWrapper<StructType>(aStruct)
    } else {
      return nil
    }
  }
}
