// Copyright © 2020 ChouTi. All rights reserved.

import CoreGraphics
import Foundation

// swiftlint:disable static_operator

// MARK: - Optional Assignment Operator

/**
 *  Optional Assignment Operator
 */
infix operator =?: AssignmentPrecedence

/**
 Optional Assignment Operator

 If the rhs is `.None` then this operator behaves as a no operation.
 If the rhs is `.Some(T) then this operator safely unwraps and binds the value so that it can be assigned to lhs

 - parameter lhs: a non-optional variable of a given type T
 - parameter rhs: an optional value of type T?
 */
public func =? <T>(lhs: inout T, rhs: T?) {
  guard let rhs = rhs else {
    return
  }
  lhs = rhs
}

/**
 Optional Assignment Operator

 If the rhs is `.None` then this operator behaves as a no operation.
 If the rhs is `.Some(T) then this operator safely unwraps and binds the value so that it can be assigned to lhs

 - parameter lhs: a non-optional variable of a given type T
 - parameter rhs: an optional value of type T?
 */
public func =? <T>(lhs: inout T?, rhs: T?) {
  guard let rhs = rhs else {
    return
  }
  lhs = rhs
}

// MARK: - Optional String Coalescing Operator

/// Optional String Coalescing Operator
/// Ref: https://oleb.net/blog/2016/12/optionals-string-interpolation/
infix operator ???: NilCoalescingPrecedence

public func ??? <T>(lhs: T?, defaultValue: @autoclosure () -> String) -> String {
  switch lhs {
  case let value?:
    return String(describing: value)
  case nil:
    return defaultValue()
  }
}
