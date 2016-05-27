//
//  Operators.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-27.
//
//

import Foundation

/**
 *  Optional Assignment Operator
 */
infix operator =? { associativity right precedence 90 }

/**
 Optional Assignment Operator
 
 If the rhs is `.None` then this operator behaves as a no operation.
 If the rhs is `.Some(T) then this operator safely unwraps and binds the value so that it can be assigned to lhs
 
 - parameter lhs: a non-optional varaible of a given type T
 - parameter rhs: an optional value of type T?
 */
public func =? <T>(inout lhs: T, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}

/**
 Optional Assignment Operator
 
 If the rhs is `.None` then this operator behaves as a no operation.
 If the rhs is `.Some(T) then this operator safely unwraps and binds the value so that it can be assigned to lhs
 
 - parameter lhs: a non-optional varaible of a given type T
 - parameter rhs: an optional value of type T?
 */
public func =? <T>(inout lhs: T?, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}
