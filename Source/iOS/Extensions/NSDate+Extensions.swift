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
			NSLog("Error: no calendar \"NSCalendarIdentifierGregorian\" found")
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
			NSLog("Error: randoming failed")
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


public extension NSDate {
	private var gregorianCalendar: NSCalendar {
		guard let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian) else {
			NSLog("Error: no calendar \"NSCalendarIdentifierGregorian\" found")
			return NSCalendar.currentCalendar()
		}
		
		return calendar
	}
	
	public var year: Int {
		return gregorianCalendar.components(.Year, fromDate: self).year
	}
	
	public func yearInTimeZone(timeZone: NSTimeZone) -> Int {
		let calendar = gregorianCalendar
		calendar.timeZone = timeZone
		return yearInCalendar(calendar)
	}
	
	public func yearInCalendar(calendar: NSCalendar) -> Int {
		return calendar.components(.Year, fromDate: self).year
	}
	
	public var month: Int {
		return gregorianCalendar.components(.Month, fromDate: self).month
	}
	
	public func monthInTimeZone(timeZone: NSTimeZone) -> Int {
		let calendar = gregorianCalendar
		calendar.timeZone = timeZone
		return monthInCalendar(calendar)
	}
	
	public func monthInCalendar(calendar: NSCalendar) -> Int {
		return calendar.components(.Month, fromDate: self).month
	}
	
	public var day: Int {
		return gregorianCalendar.components(.Day, fromDate: self).day
	}
	
	public func dayInTimeZone(timeZone: NSTimeZone) -> Int {
		let calendar = gregorianCalendar
		calendar.timeZone = timeZone
		return dayInCalendar(calendar)
	}
	
	public func dayInCalendar(calendar: NSCalendar) -> Int {
		return calendar.components(.Day, fromDate: self).day
	}
	
	public var hour: Int {
		return gregorianCalendar.components(.Hour, fromDate: self).hour
	}
	
	public func hourInTimeZone(timeZone: NSTimeZone) -> Int {
		let calendar = gregorianCalendar
		calendar.timeZone = timeZone
		return hourInCalendar(calendar)
	}
	
	public func hourInCalendar(calendar: NSCalendar) -> Int {
		return calendar.components(.Hour, fromDate: self).hour
	}
	
	public var minute: Int {
		return gregorianCalendar.components(.Minute, fromDate: self).minute
	}
	
	public func minuteInTimeZone(timeZone: NSTimeZone) -> Int {
		let calendar = gregorianCalendar
		calendar.timeZone = timeZone
		return minuteInCalendar(calendar)
	}
	
	public func minuteInCalendar(calendar: NSCalendar) -> Int {
		return calendar.components(.Minute, fromDate: self).minute
	}
	
	public var second: Int {
		return gregorianCalendar.components(.Second, fromDate: self).second
	}
	
	public func secondInTimeZone(timeZone: NSTimeZone) -> Int {
		let calendar = gregorianCalendar
		calendar.timeZone = timeZone
		return secondInCalendar(calendar)
	}
	
	public func secondInCalendar(calendar: NSCalendar) -> Int {
		return calendar.components(.Second, fromDate: self).second
	}
	
	public var weekday: Int {
		return gregorianCalendar.components(.Weekday, fromDate: self).weekday
	}
	
	public func weekdayInTimeZone(timeZone: NSTimeZone) -> Int {
		let calendar = gregorianCalendar
		calendar.timeZone = timeZone
		return weekdayInCalendar(calendar)
	}
	
	public func weekdayInCalendar(calendar: NSCalendar) -> Int {
		return calendar.components(.Weekday, fromDate: self).weekday
	}
}
