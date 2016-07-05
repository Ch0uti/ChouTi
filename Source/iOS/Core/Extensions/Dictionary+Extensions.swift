//
//  Dictionary+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-28.
//
//

import Foundation

// MARK: - Merge Operator for Dictionary

/**
Merge two dictionaries

- parameter left:  left operand dictionary
- parameter right: right operand dictionary

- returns: Merge dictionary, existed keys in left dictionary will be overrided by right dictionary
*/
@warn_unused_result
public func + <K: Hashable, V, S: SequenceType where S.Generator.Element == Dictionary<K, V>.Element> (left: Dictionary<K, V>, right: S?) -> Dictionary<K, V> {
    guard let right = right else { return left }
    return right.reduce(left) {
        var new = $0
        new.updateValue($1.1, forKey: $1.0)
        return new
    }
}

/**
 Merge two dictionaries
 
 - parameter left:  left operand dictionary
 - parameter right: right operand dictionary
 */
public func += <K: Hashable, V, S: SequenceType where S.Generator.Element == (K, V)> (inout left: Dictionary<K, V>, right: S?) {
    guard let right = right else { return }
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

public extension Dictionary {
    @warn_unused_result
    public func merge<S: SequenceType where S.Generator.Element == (Key, Value)>(other: S) -> Dictionary<Key, Value> {
        var result = self
        result.mergeInPlace(other)
        return result
    }
    
    public mutating func mergeInPlace<S: SequenceType where S.Generator.Element == (Key, Value)>(other: S) {
        for (key, value) in other {
            self[key] = value
        }
    }
    
    init<S: SequenceType where S.Generator.Element == (Key, Value)>(_ sequence: S) {
        self = [:]
        self.mergeInPlace(sequence)
    }
    
    public func mapValues<NewValue>(transform: Value -> NewValue) -> [Key : NewValue] {
        return Dictionary<Key, NewValue>(self.map { ($0, transform($1)) })
    }
    
    @warn_unused_result
    func randomSubDictionary() -> Dictionary<Key, Value> {
        return self.randomSubset().reduce([:]) {
            var new = $0
            new.updateValue($1.1, forKey: $1.0)
            return new
        }
    }
}
