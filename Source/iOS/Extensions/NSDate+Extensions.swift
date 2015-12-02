//
//  NSDate+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-16.
//
//

import Foundation

public extension NSDate {
	/**
	Get a random day within days before today
	
	- parameter days: days before
	
	- returns: new NSDate
	*/
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
	/**
	Get a random NSDate object, date is after 1970
	
	- returns: a random NSDate
	*/
	public static func random() -> NSDate {
		let randomTime = NSTimeInterval(arc4random_uniform(UInt32.max))
		return NSDate(timeIntervalSince1970: randomTime)
	}
}



// MARK: - Comparison
public extension NSDate {
	public func isEarlierThanDate(date: NSDate) -> Bool {
		if self.compare(date) == .OrderedAscending {
			return true
		} else {
			return false
		}
	}
	
	public func isBeforeDate(date: NSDate) -> Bool {
		return isEarlierThanDate(date)
	}
	
	public func isLaterThanDate(date: NSDate) -> Bool {
		if self.compare(date) == .OrderedDescending {
			return true
		} else {
			return false
		}
	}
	
	public func isAfterDate(date: NSDate) -> Bool {
		return isLaterThanDate(date)
	}
}


public extension NSDate {
	public func dateByAddingDays(daysToAdd: Double) -> NSDate {
		let secondsInDays: NSTimeInterval = daysToAdd * 60 * 60 * 24
		return self.dateByAddingTimeInterval(secondsInDays)
	}
	
	public func dateByAddingHours(hoursToAdd: Double) -> NSDate {
		let secondsInHours: NSTimeInterval = hoursToAdd * 60 * 60
		return self.dateByAddingTimeInterval(secondsInHours)
	}
	
	public func dateByAddingMinutes(minutesToAdd: Double) -> NSDate {
		let secondsInMinutes: NSTimeInterval = minutesToAdd * 60
		return self.dateByAddingTimeInterval(secondsInMinutes)
	}
	
	public func dateByAddingSeconds(secondsToAdd: Double) -> NSDate {
		return self.dateByAddingTimeInterval(secondsToAdd)
	}
}
