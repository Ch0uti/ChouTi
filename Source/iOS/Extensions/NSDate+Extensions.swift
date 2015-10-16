//
//  NSDate+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-16.
//
//

import Foundation

public extension NSDate {
	public class func randomWithinDaysBeforeToday(days: Int) -> NSDate {
		let today = NSDate()
		
		guard let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {
			print("no calendar \"NSCalendarIdentifierGregorian\" found")
			return today
		}
		
		let r1 = arc4random_uniform(UInt32(days))
		let r2 = arc4random_uniform(UInt32(23))
		let r3 = arc4random_uniform(UInt32(23))
		let r4 = arc4random_uniform(UInt32(23))
		
		let offsetComponents = NSDateComponents()
		offsetComponents.day = Int(r1) * -1
		offsetComponents.hour = Int(r2)
		offsetComponents.minute = Int(r3)
		offsetComponents.second = Int(r4)
		
		guard let rndDate1 = gregorian.dateByAddingComponents(offsetComponents, toDate: today, options: []) else {
			print("randoming failed")
			return today
		}
		return rndDate1
	}
	
	public static func random() -> NSDate {
		let randomTime = NSTimeInterval(arc4random_uniform(UInt32.max))
		return NSDate(timeIntervalSince1970: randomTime)
	}
	
}
