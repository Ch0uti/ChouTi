//
//  NSCalendar+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import Foundation

public extension NSCalendar {
	static public func weekdayNameFromWeekdayNumber(number: Int) -> String? {
		switch number {
		case 0:
			return "Sunday"
		case 1:
			return "Monday"
		case 2:
			return "Tuesday"
		case 3:
			return "Wednesday"
		case 4:
			return "Thursday"
		case 5:
			return "Friday"
		case 6:
			return "Saturday"
		default:
			return nil
		}
	}
}
