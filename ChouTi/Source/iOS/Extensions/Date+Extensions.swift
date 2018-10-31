//
//  Date+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-10-16.
//
//

import Foundation

// MARK: - Random date
public extension Date {
	/// Get a random day before a date, within certain amount of days. Time is same as today's.
	///
	/// - Parameters:
	///   - date: the date before with
	///   - days: the amount of days before (at least 1 day)
	/// - Returns: a random day or nil
	public static func randomDate(before date: Date, withinDays: Int) -> Date? {
		let days = withinDays.normalize(1, Int.max)
        return Calendar.autoupdatingCurrent.date(byAdding: .day, value: -Int.random(in: 1...days), to: date)
    }
	
    /// Get a random Date object, date is after 1970
    ///
    /// - Returns: a random Date after 1970
    public static func random() -> Date {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return Date(timeIntervalSince1970: randomTime)
    }
}

// MARK: - Manipulate date

// MARK: - Get components from date
public extension Date {
	private var autoupdatingCalendar: Calendar {
		var calendar = Calendar.autoupdatingCurrent
		calendar.timeZone = TimeZone.autoupdatingCurrent
		return calendar
	}
	
	public var era: Int { return autoupdatingCalendar.component(.era, from: self) }
    public var year: Int { return autoupdatingCalendar.component(.year, from: self) }
	public var month: Int { return autoupdatingCalendar.component(.month, from: self) }
	public var day: Int { return autoupdatingCalendar.component(.day, from: self) }
	public var hour: Int { return autoupdatingCalendar.component(.hour, from: self) }
	public var minute: Int { return autoupdatingCalendar.component(.minute, from: self) }
	public var second: Int { return autoupdatingCalendar.component(.second, from: self) }
	public var weekday: Int { return autoupdatingCalendar.component(.weekday, from: self) }
	public var weekdayOrdinal: Int { return autoupdatingCalendar.component(.weekdayOrdinal, from: self) }
	public var quarter: Int { return autoupdatingCalendar.component(.quarter, from: self) }
	public var weekOfMonth: Int { return autoupdatingCalendar.component(.weekOfMonth, from: self) }
	public var weekOfYear: Int { return autoupdatingCalendar.component(.weekOfYear, from: self) }
	public var yearForWeekOfYear: Int { return autoupdatingCalendar.component(.yearForWeekOfYear, from: self) }
	public var nanosecond: Int { return autoupdatingCalendar.component(.nanosecond, from: self) }
}


public extension Date {
    public static func date(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, nanosecond: Int = 0, timeZone: TimeZone? = nil, calendar: Calendar? = nil) -> Date? {
		
        var calendar = calendar ?? Calendar.autoupdatingCurrent
		calendar.timeZone = timeZone ?? TimeZone.autoupdatingCurrent

		var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: Date())
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond
		
        return calendar.date(from: components)
    }
    
    public func date(bySetting component: Calendar.Component, with newValue: Int, timeZone: TimeZone? = nil, calendar: Calendar? = nil) -> Date? {
		var calendar = calendar ?? Calendar.autoupdatingCurrent
		calendar.timeZone = timeZone ?? TimeZone.autoupdatingCurrent
		
		var components = calendar.dateComponents([.era, .year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
		
		switch component {
		case .era: components.era = newValue
		case .year: components.year = newValue
		case .month: components.month = newValue
		case .day: components.day = newValue
		case .hour: components.hour = newValue
		case .minute: components.minute = newValue
		case .second: components.second = newValue
		case .nanosecond: components.nanosecond = newValue
		default:
			NSLog("Error: unsupported calendar component: \(component)")
			break
		}
		
		return calendar.date(from: components)
    }
}
