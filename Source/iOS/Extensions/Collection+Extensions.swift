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
}
