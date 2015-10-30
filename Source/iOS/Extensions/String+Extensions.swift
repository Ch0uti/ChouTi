//
//  String+Extensions.swift
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
		return emailRegex.firstMatchInString(self, options:[], range: self.fullNSRange()) != nil
	}
	
	public func replaceRegex(regex: NSRegularExpression, withString template: String) -> String {
		return regex.stringByReplacingMatchesInString(self, options: [], range: self.fullNSRange(), withTemplate: template)
	}
	
	public func matchedStringForRegex(regex: NSRegularExpression) -> [String] {
		var matchedStrings = [String]()
		
		let matchResult = regex.matchesInString(self, options: [], range: self.fullNSRange())
		for match in matchResult {
			if let range = rangeFromNSRange(match.range) {
				matchedStrings.append(self.substringWithRange(range))
			}
		}
		
		return matchedStrings
	}
	
	public func firstMatchStringForRegex(regex: NSRegularExpression) -> String? {
		let matchResult = regex.firstMatchInString(self, options: [], range: self.fullNSRange())
		if let nsRange = matchResult?.range, let range = rangeFromNSRange(nsRange) {
			return self.substringWithRange(range)
		}
		
		return nil
	}
	
	public func fullNSRange() -> NSRange {
		return NSRange(location: 0, length: self.startIndex.distanceTo(self.endIndex))
	}
	
	public func rangeFromNSRange(nsRange: NSRange) -> Range<String.Index>? {
		let from = self.startIndex.advancedBy(nsRange.location, limit: self.endIndex)
		let to = from.advancedBy(nsRange.length, limit: self.endIndex)
		return from ..< to
	}

	/**
	Strips leading and trailing white-space from a string, replaces sequences of whitespace characters by a single space, and returns the resulting string.
	
	- returns: Normalized string
	*/
	public func normalizeSpaces() -> String {
		let whiteSpacesExceptLastOne = NSRegularExpression.whiteSpacesExceptLastOne()
		let tabNewlineSpaceRegex = NSRegularExpression.tabNewlineSpaceRegex()
		return self.replaceRegex(whiteSpacesExceptLastOne, withString: "").replaceRegex(tabNewlineSpaceRegex, withString: " ").trimmed()
	}
	
	public func removeTabsAndReplaceNewlineWithEmptySpace() -> String {
		let tabRegex = NSRegularExpression.tabRegex()
		let newLineRegex = NSRegularExpression.newlineRegex()
		let whiteSpaceRegex = NSRegularExpression.whiteSpaceRegex()
		
		return self.replaceRegex(tabRegex, withString: "").replaceRegex(newLineRegex, withString: " ").replaceRegex(whiteSpaceRegex, withString: " ")
	}
	
	public func percentNumberString() -> String? {
		let percentRegex = NSRegularExpression.percentNumberRegex()
		return firstMatchStringForRegex(percentRegex)
	}
}
