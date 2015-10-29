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

// MARK: - Regex Related
public extension String {
	public func isEmail() -> Bool {
		let emailRegex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.CaseInsensitive])
		return emailRegex.firstMatchInString(self, options:[], range: NSMakeRange(0, utf16.count)) != nil
	}
	
	public func replaceRegex(regex: NSRegularExpression, withString template: String) -> String {
		return regex.stringByReplacingMatchesInString(self, options: [], range: NSRange(location: 0, length: self.characters.count), withTemplate: template)
	}
	
	public func removeTabsAndReplaceNewlineWithEmptySpace() -> String {
		let tabRegex = NSRegularExpression.tabRegex()
		let newLineRegex = NSRegularExpression.newlineRegex()
		let whiteSpaceRegex = NSRegularExpression.whiteSpaceRegex()
		
		return self.replaceRegex(tabRegex, withString: "").replaceRegex(newLineRegex, withString: " ").replaceRegex(whiteSpaceRegex, withString: " ")
	}
}
