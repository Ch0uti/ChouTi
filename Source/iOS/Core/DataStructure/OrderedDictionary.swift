//
//  OrderedDictionary.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-25.
//
//

import Foundation

public struct OrderedDictionary<KeyType: Hashable, ValueType> {
	public typealias ArrayType = [KeyType]
	public typealias DictionaryType = [KeyType: ValueType]
	
	public var array = ArrayType()
	public var dictionary = DictionaryType()
	
	public var count: Int { return array.count }
	
	public subscript(key: KeyType) -> ValueType? {
		get {
			return dictionary[key]
		}
		
		set {
			if let _ = array.index(of: key) {
			} else {
				array.append(key)
			}
			
			dictionary[key] = newValue
		}
	}
	
	public subscript(index: Int) -> (KeyType, ValueType) {
		get {
			precondition(index < array.count, "index out of bounds")
			
			let key = array[index]
			let value = dictionary[key]!
			
			return (key, value)
		}
	}
}

extension OrderedDictionary {
	public mutating func insert(_ value: ValueType, forKey key: KeyType, atIndex index: Int) -> ValueType? {
		var adjustedIndex = index
		
		// If insert for key: b, at index 2
		//
		//        |
		//        v
		//   0    1    2
		// ["a", "b", "c"]
		// 
		// Remove "b"
		//   0    1
		// ["a", "c"]
		
		let existingValue = dictionary[key]
		if existingValue != nil {
			let existingIndex = array.index(of: key)!
			
			if existingIndex < index {
				adjustedIndex -= 1
			}
			
			array.remove(at: existingIndex)
		}
		array.insert(key, at: adjustedIndex)
		dictionary[key] = value
		
		return existingValue
	}
	
	public mutating func removeAtIndex(_ index: Int) -> (KeyType, ValueType) {
		precondition(index < array.count, "index out of bounds")
		
		let key = array.remove(at: index)
		let value = dictionary.removeValue(forKey: key)
		
		return (key, value!)
	}
}
