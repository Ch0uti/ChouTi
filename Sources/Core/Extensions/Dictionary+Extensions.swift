// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

// MARK: - Merging for Dictionary

public extension Dictionary {
    /// Merge with another dictionary, existing keys in left dictionary are overrided by keys right dictionary.
    mutating func merge(with another: [Key: Value]) {
        for (k, v) in another {
            updateValue(v, forKey: k)
        }
    }

    /// Returns a new dictionary by merging right dictionary into left dictionary.
    func merged(with another: [Key: Value]) -> [Key: Value] {
        var result = self
        result.merge(with: another)
        return result
    }

    /// Merge two dictionaries.
    ///
    /// - Parameters:
    ///   - left: left dictionary
    ///   - right: right dictionary
    /// - Returns: Merged dictionary, existing keys in left dictionary is overrided by right dictionary.
    static func + (left: [Key: Value], right: [Key: Value]?) -> [Key: Value] {
        guard let right = right else {
            return left
        }
        return left.merged(with: right)
    }

    /// Merge two dictionaries and left is updated.
    ///
    /// - Parameters:
    ///   - left: left dictionary
    ///   - right: right dictionary
    static func += (left: inout [Key: Value], right: [Key: Value]?) {
        guard let right = right else {
            return
        }
        left.merge(with: right)
    }
}

// MARK: - Random Subset

public extension Dictionary {
    /// Returns a random subsect of the dictionary.
    func randomSubset() -> [Key: Value] {
        return filter { _ in Bool.random() }.reduce([:]) {
            $0.merged(with: [$1.key: $1.value])
        }
    }
}
