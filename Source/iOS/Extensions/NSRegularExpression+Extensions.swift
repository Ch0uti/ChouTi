//
//  NSRegularExpression+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-28.
//
//

import Foundation

public extension NSRegularExpression {
	public class func tabRegex() -> NSRegularExpression {
		return try! NSRegularExpression(pattern: "[\t]+", options: [])
	}
	
	public class func newlineRegex() -> NSRegularExpression {
		return try! NSRegularExpression(pattern: "[\r\n|\r|\n]+", options: [])
	}
	
	public class func whiteSpaceRegex() -> NSRegularExpression {
		return try! NSRegularExpression(pattern: "[\\s]+", options: [])
	}
}
