//
//  Dictionary+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-28.
//
//

import Foundation

// MARK: - Merging for Dictionary
extension Dictionary {
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
	
	/// Merge two dictionaries
	///
	/// - Parameters:
	///   - left: left dictionary
	///   - right: right dictionary
	/// - Returns: Merged dictionary, existing keys in left dictionary is overrided by right dictionary
	public static func + (left: [Key : Value], right: [Key : Value]?) -> [Key : Value] {
		guard let right = right else { return left }
		return left.merge(with: right)
	}
	
	/// Merge two dictionaries and left is updated
	///
	/// - Parameters:
	///   - left: left dictionary
	///   - right: right dictionary
	public static func += (left: inout [Key : Value], right: [Key : Value]?) {
		guard let right = right else { return }
		left.merged(with: right)
	}
}

// MARK: - Random Subset
extension Dictionary {
	public func randomSubset() -> [Key : Value] {
        return self.filter({ _ in Bool.random() }).reduce([:]) {
            $0.merge(with: [$1.key : $1.value])
        }
	}
}
