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
			if let _ = array.indexOf(key) {
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
	public mutating func insert(value: ValueType, forKey key: KeyType, atIndex index: Int) -> ValueType? {
		var adjustedIndex = index
		
		let existingValue = dictionary[key]
		if existingValue != nil {
			let existingIndex = array.indexOf(key)
			
			if existingIndex < index {
				adjustedIndex--
			}
			
			array.removeAtIndex(existingIndex!)
		}
		array.insert(key, atIndex: adjustedIndex)
		dictionary[key] = value
		
		return existingValue
	}
	
	public mutating func removeAtIndex(index: Int) -> (KeyType, ValueType) {
		precondition(index < array.count, "index out of bounds")
		
		let key = array.removeAtIndex(index)
		let value = dictionary.removeValueForKey(key)
		
		return (key, value!)
	}
}
