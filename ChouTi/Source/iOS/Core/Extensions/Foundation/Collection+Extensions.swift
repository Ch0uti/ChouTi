//
//  Collection+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-10-16.
//
//

import Foundation

#if os(OSX) || os(iOS)
	import Darwin
	
	fileprivate let random: (Int) -> Int = { Int(arc4random_uniform(UInt32($0))) }
#else
	import Glibc
	
	fileprivate let random: (Int) -> Int = {
		while true {
			let x = Glibc.random() % $0
			let y = Glibc.random() % $0
			guard x == y else { return x }
		}
}
#endif

public extension Collection {
    /**
     Returns an optional element. If the `index` does not exist in the collection, the subscript returns nil.
     
     - parameter safe: The index of the element to return, if it exists.
     
     - returns: An optional element from the collection at the specified index.
     */
    public subscript (safe index: Index) -> Iterator.Element? {
        return at(index)
    }
    
    /**
     Returns an optional element. If the `index` does not exist in the collection, the function returns nil.
     
     - parameter index: The index of the element to return, if it exists.
     
     - returns: An optional element from the collection at the specified index.
     */
    public func at(_ index: Index) -> Iterator.Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
	
//    /**
//     Return a random item from the array
//     
//     - returns: a random item in the array
//     */
//    public func randomItem() -> Iterator.Element {
//        if isEmpty {
//            fatalError("Emoty collection has no item")
//        }
//        
//        let randomDistance = Index.Distance(arc4random_uniform(UInt32(count.toIntMax())).toIntMax())
//        let randomIndex = index.index(startIndex, offsetBy: randomDistance)
//        return self[randomIndex]
//    }
}

public extension Collection {
    /**
     Returns a random element from the collection.
     
     - returns: A random element from the collection.
     */
    public func randomItem() -> Iterator.Element {
        if isEmpty {
            fatalError("Emoty collection has no item")
        }
		
		return self[index(startIndex, offsetBy: random(self.count))]
    }
}

// MARK: - Shuffle
// Ref: https://github.com/apple/example-package-fisheryates/blob/master/Sources/Fisher-Yates_Shuffle.swift
public extension Collection {
	/// Creats a shuffled version of this array using the Fisher-Yates (fast and uniform) shuffle.
	/// From http://stackoverflow.com/a/24029847/194869
	///
	/// - Returns: A shuffled version of this collection.
	public func shuffled() -> [Iterator.Element] {
		var array = Array(self)
		array.shuffle()
		return array
	}
}

public extension MutableCollection where Index == Int {
    /// Shuffle the array using the Fisher-Yates (fast and uniform) shuffle. Mutating.
	/// From http://stackoverflow.com/a/24029847/194869
    public mutating func shuffle() {
        guard count > 1 else { return }
        
        for i in 0..<count - 1 {
			let j = random(count - i) + i
            guard i != j else { continue }
            self.swapAt(i, j)
        }
    }
}
