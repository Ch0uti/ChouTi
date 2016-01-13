//
//  NSTimeZone+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-13.
//
//

import Foundation

public extension NSTimeZone {
	public static func GMT() -> NSTimeZone {
		guard let gmt = NSTimeZone(abbreviation: "GMT") else {
			NSLog("Error: time zone with `GMT` abbreviation not found")
			return NSTimeZone.defaultTimeZone()
		}
		return gmt
	}
	
	public static func EST() -> NSTimeZone {
		guard let est = NSTimeZone(abbreviation: "EST") else {
			NSLog("Error: time zone with `EST` abbreviation not found")
			return NSTimeZone.defaultTimeZone()
		}
		return est
	}
}
