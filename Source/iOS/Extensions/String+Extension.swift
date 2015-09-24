//
//  String+Extension.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-24.
//
//

import Foundation

public extension String {
	
	/**
	Return whitespace and newline trimmed string.
	
	- returns: whitespace and newline trimmed string
	*/
	public func trimmed() -> String {
		return self.whitespaceAndNewlineTrimmed()
	}
	
	/**
	Return whitespace and newline trimmed string.
	
	- returns: whitespace and newline trimmed string
	*/
	public func whitespaceAndNewlineTrimmed() -> String {
		return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}
	
	/**
	Return whitespace trimmed string.
	
	- returns: whitespace trimmed string
	*/
	public func whitespaceTrimmed() -> String {
		return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
	}
}
