//
//  Created by Honghao Zhang on 10/16/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

// MARK: - Random date
public extension Date {

    /// Get random int from a range of Int.
    private static func randomInt(from range: Range<Int>) -> Int {
        if range.lowerBound == range.upperBound {
            return range.lowerBound
        }
        return Int.random(in: range.lowerBound..<range.upperBound)
    }

    /// Returns a random date within the specified date range.
    static func randomDate(in range: Range<Date>) -> Date? {
        guard range.lowerBound < range.upperBound else {
            return nil
        }

        return Date(year: randomInt(from: range.lowerBound.year..<range.upperBound.year),
                    month: randomInt(from: range.lowerBound.month..<range.upperBound.month),
                    day: randomInt(from: range.lowerBound.day..<range.upperBound.day),
                    hour: randomInt(from: range.lowerBound.hour..<range.upperBound.hour),
                    minute: randomInt(from: range.lowerBound.minute..<range.upperBound.minute),
                    second: randomInt(from: range.lowerBound.second..<range.upperBound.second),
                    nanosecond: randomInt(from: range.lowerBound.nanosecond..<range.upperBound.nanosecond),
                    timeZone: TimeZone.autoupdatingCurrent,
                    calendar: Calendar.autoupdatingCurrent)
    }

    /// Returns a random date within the specified date range.
    static func randomDate(in range: ClosedRange<Date>) -> Date? {
        return Date(year: Int.random(in: range.lowerBound.year...range.upperBound.year),
                    month: Int.random(in: range.lowerBound.month...range.upperBound.month),
                    day: Int.random(in: range.lowerBound.day...range.upperBound.day),
                    hour: Int.random(in: range.lowerBound.hour...range.upperBound.hour),
                    minute: Int.random(in: range.lowerBound.minute...range.upperBound.minute),
                    second: Int.random(in: range.lowerBound.second...range.upperBound.second),
                    nanosecond: Int.random(in: range.lowerBound.nanosecond...range.upperBound.nanosecond),
                    timeZone: TimeZone.autoupdatingCurrent,
                    calendar: Calendar.autoupdatingCurrent)
    }

    /// Get a random date which is after 00:00:00 UTC on 1 January 1970.
    static func randomDateSince1970() -> Date {
        return Date(timeIntervalSince1970: TimeInterval.random(in: 0..<TimeInterval(Int.max)))
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

    var era: Int { return autoupdatingCalendar.component(.era, from: self) }
    var year: Int { return autoupdatingCalendar.component(.year, from: self) }
    var month: Int { return autoupdatingCalendar.component(.month, from: self) }
    var day: Int { return autoupdatingCalendar.component(.day, from: self) }
	var hour: Int { return autoupdatingCalendar.component(.hour, from: self) }
	var minute: Int { return autoupdatingCalendar.component(.minute, from: self) }
	var second: Int { return autoupdatingCalendar.component(.second, from: self) }
	var weekday: Int { return autoupdatingCalendar.component(.weekday, from: self) }
	var weekdayOrdinal: Int { return autoupdatingCalendar.component(.weekdayOrdinal, from: self) }
	var quarter: Int {
        // Ref: https://nshipster.com/datecomponents See: rdar://35247464.
        let formatter = DateFormatter()
        formatter.dateFormat = "Q"
        return Int(formatter.string(from: self)) ?? autoupdatingCalendar.component(.quarter, from: self)
    }
	var weekOfMonth: Int { return autoupdatingCalendar.component(.weekOfMonth, from: self) }
	var weekOfYear: Int { return autoupdatingCalendar.component(.weekOfYear, from: self) }
	var yearForWeekOfYear: Int { return autoupdatingCalendar.component(.yearForWeekOfYear, from: self) }
	var nanosecond: Int { return autoupdatingCalendar.component(.nanosecond, from: self) }
}

public extension Date {
    /// Initialize a Date object by setting date components.
    init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, nanosecond: Int = 0, timeZone: TimeZone? = nil, calendar: Calendar? = nil) {
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

        guard let date = calendar.date(from: components) else {
            return nil
        }
        self = date
    }

    func setting(_ component: Calendar.Component, with newValue: Int, timeZone: TimeZone? = nil, calendar: Calendar? = nil) -> Date? {
		var calendar = calendar ?? Calendar.autoupdatingCurrent
        let timeZone = timeZone ?? TimeZone.autoupdatingCurrent
		calendar.timeZone = timeZone

        var components = calendar.dateComponents(in: timeZone, from: self)
        switch component {
        case .era:
            components.era = newValue
        case .year:
            components.year = newValue
            components.yearForWeekOfYear = nil
        case .month:
            components.month = newValue
        case .day:
            components.day = newValue
        case .hour:
            components.hour = newValue
        case .minute:
            components.minute = newValue
        case .second:
            components.second = newValue
        case .weekday:
            components.day = (components.day ?? 0) + (newValue - (components.weekday ?? 0))
            components.weekday = newValue
        case .weekdayOrdinal:
            components.weekdayOrdinal = newValue
//            components.day = nil
        case .quarter:
            components.quarter = newValue
        case .weekOfMonth:
            components.weekOfMonth = newValue
        case .weekOfYear:
            components.weekOfYear = newValue
        case .yearForWeekOfYear:
            components.yearForWeekOfYear = newValue
        case .nanosecond:
            components.nanosecond = newValue
        case .timeZone, .calendar:
            NSLog("Error: unsupported calendar component: \(component)")
        }

		return calendar.date(from: components)
    }
}
