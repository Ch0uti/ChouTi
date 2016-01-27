//
//  Collection+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-16.
//
//

import Foundation

public extension Array {
	/**
	Return a random item from the array
	
	- returns: a random item in the array
	*/
	public func randomItem() -> Element {
		let index = Int(arc4random_uniform(UInt32(self.count)))
		return self[index]
	}
	
	/**
	Shuffle the array
	*/
	public mutating func shuffle() {
		if count == 0 {
			return
		}
		for i in 0..<(count - 1) {
			let j = Int(arc4random_uniform(UInt32(count - i))) + i
			swap(&self[i], &self[j])
		}
	}
	
	/**
	Return a random subset
	
	- returns: a random subset
	*/
	public func randomSubset() -> [Element] {
		if count == 0 {
			return self
		}
		
		let left = Int.random(0, count - 1)
		let right = Int.random(left, count - 1)
		
		var result = [Element]()
		for i in left ... right {
			result.append(self[i])
		}
		
		return result
	}
}
