//
//  SequenceType+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-03.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation

public extension SequenceType {
    /**
     Return a random subset
     
     - returns: a random subset
     */
    public func randomSubset() -> [Generator.Element] {
        return self.filter { _ in Bool.random() }
    }
    
    /**
     If all element match predicate

     - parameter predicate: predicate criterion
     
     - returns: true if all match.
     */
    public func allMatch(predicate: Generator.Element -> Bool) -> Bool {
        // every element matches a predicate if no element doesn't match it
        return !self.contains { !predicate($0) }
    }
}

public extension SequenceType where Generator.Element: Hashable {
    /**
     Find all unique elements in a sequence while still maintaining the original order.
     
     - returns: Unique items with order preserved.
     */
    public func unique() -> [Generator.Element] {
        var seen: Set<Generator.Element> = []
        return self.filter {
            if seen.contains($0) {
                return false
            } else {
                seen.insert($0)
                return true
            }
        }
    }
}
