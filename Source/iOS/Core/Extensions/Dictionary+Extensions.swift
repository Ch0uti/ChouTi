//
//  Dictionary+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-28.
//
//

import Foundation

// MARK: - Merging for Dictionary
public extension Dictionary {
	public mutating func merged(with another: [Key : Value]) {
		for (k, v) in another {
			self.updateValue(v, forKey: k)
		}
	}
	
	public func merge(with another: [Key : Value]) -> [Key : Value] {
		var result = self
		result.merged(with: another)
		return result
	}
}

/// Merge two dictionaries
///
/// - Parameters:
///   - left: left dictionary
///   - right: right dictionary
/// - Returns: Merged dictionary, existing keys in left dictionary is overrided by right dictionary
public func + <K, V> (left: [K : V], right: [K : V]?) -> [K : V] {
    guard let right = right else { return left }
	return left.merge(with: right)
}

/// Merge two dictionaries and left is updated
///
/// - Parameters:
///   - left: left dictionary
///   - right: right dictionary
public func += <K, V> (left: inout [K : V], right: [K : V]?) {
    guard let right = right else { return }
	left.merged(with: right)
}

// MARK: - Random Subset
public extension Dictionary {
	func randomSubset() -> [Key : Value] {
		return self.filter({ _ in Bool.random() }).reduce([:]) {
			$0.0.merge(with: [$0.1.key : $0.1.value])
		}
	}
}
