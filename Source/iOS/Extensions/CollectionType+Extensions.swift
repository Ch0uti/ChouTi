//
//  CollectionType+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-16.
//
//

import Foundation

public extension CollectionType {
    /**
     Return a random item from the array
     
     - returns: a random item in the array
     */
    @warn_unused_result
    public func randomItem() -> Generator.Element {
        if isEmpty {
            fatalError("Emoty collection has no item")
        }
        
        let randomDistance = Index.Distance(arc4random_uniform(UInt32(count.toIntMax())).toIntMax())
        let randomIndex = startIndex.advancedBy(randomDistance)
        return self[randomIndex]
    }
    
    /**
     Creats a shuffled version of this array using the Fisher-Yates (fast and uniform) shuffle.
     Non-mutating. 
     From http://stackoverflow.com/a/24029847/194869
     
     - returns: A shuffled version of this array.
     */
    @warn_unused_result
    public func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

public extension CollectionType where Self.Index == Int {
    /**
     Returns an optional element. If the `index` does not exist in the collection, the subscript returns nil.
     
     - parameter safe: The index of the element to return, if it exists.
     
     - returns: An optional element from the collection at the specified index.
     */
    public subscript (safe index: Int) -> Self.Generator.Element? {
        return at(index)
    }
    
    /**
     Returns an optional element. If the `index` does not exist in the collection, the function returns nil.
     
     - parameter index: The index of the element to return, if it exists.
     
     - returns: An optional element from the collection at the specified index.
     */
    @warn_unused_result
    public func at(index: Int) -> Self.Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /**
     Returns a random element from the collection.
     
     - returns: A random element from the collection.
     */
    @warn_unused_result
    public func randomItem() -> Generator.Element {
        if isEmpty {
            fatalError("Emoty collection has no item")
        }
        
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

public extension MutableCollectionType where Index == Int {
    /**
     Shuffle the array using the Fisher-Yates (fast and uniform) shuffle. Mutating.
     From http://stackoverflow.com/a/24029847/194869
     */
    public mutating func shuffleInPlace() {
        // Empty and single-element collections don't shuffle.
        guard count > 1 else { return }
        
        for i in 0 ..< (count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
