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
infix operator =? {
    associativity right
    precedence 90
    assignment
}

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

/**
 *  Power Operator
 */
infix operator ** {
    associativity none
    precedence 160
}

@warn_unused_result
/**
 Compute base raised to the power power.
 
 - parameter base:  base numbr.
 - parameter power: power number.
 
 - returns: base raised to the power.
 */
func ** (base: Double, power: Double) -> Double {
    return pow(base, power)
}

func ** (base: CGFloat, power: CGFloat) -> CGFloat {
    return pow(base, power)
}

func ** (base: Float, power: Float) -> Float {
    return powf(base, power)
}

func ** (base: Int, power: Int) -> Int {
    return Int(pow(Double(base), Double(power)))
}
