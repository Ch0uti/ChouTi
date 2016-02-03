//
//  Dictionary+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-28.
//
//

import Foundation

// MARK: - Plus Operator for Dictionary

/**
Combine two dictionaries

- parameter left:  left operand dictionary
- parameter right: right operand dictionary

- returns: Combined dictionary, existed keys in left dictionary will be overrided by right dictionary
*/
public func + <K: Hashable, V> (left: [K : V], right: [K : V]?) -> [K : V] {
    guard let right = right else { return left }
    return right.reduce(left) {
        var new = $0
        new.updateValue($1.1, forKey: $1.0)
        return new
    }
}

/**
 Combine two dictionaries
 
 - parameter left:  left operand dictionary
 - parameter right: right operand dictionary
 */
public func += <K: Hashable, V> (inout left: [K : V], right: [K : V]?){
    guard let right = right else { return }
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
