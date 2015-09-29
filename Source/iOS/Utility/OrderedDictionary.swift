//
//  OrderedDictionary.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-25.
//
//

import Foundation

struct OrderedDictionary<KeyType: Hashable, ValueType> {
	typealias ArrayType = [KeyType]
	typealias DictionaryType = [KeyType: ValueType]
	
	var array = ArrayType()
	var dictionary = DictionaryType()
	
	var count: Int { return array.count }
	
	subscript(key: KeyType) -> ValueType? {
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
	
	subscript(index: Int) -> (KeyType, ValueType) {
		get {
			precondition(index < array.count, "index out of bounds")
			
			let key = array[index]
			let value = dictionary[key]!
			
			return (key, value)
		}
	}
}

extension OrderedDictionary {
	mutating func insert(value: ValueType, forKey key: KeyType, atIndex index: Int) -> ValueType? {
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
	
	mutating func removeAtIndex(index: Int) -> (KeyType, ValueType) {
		precondition(index < array.count, "index out of bounds")
		
		let key = array.removeAtIndex(index)
		let value = dictionary.removeValueForKey(key)
		
		return (key, value!)
	}
}
