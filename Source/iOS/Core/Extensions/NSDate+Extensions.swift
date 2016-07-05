//
//  NSDate+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-16.
//
//

import Foundation

// MARK: - Random date
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
extension NSDate : Comparable{
	/**
	Whether self date is earlier than another date
	
	- parameter date: another date to compare
	
	- returns: true if self is earlier than another date, otherwise, false.
	*/
    public func isEarlierThanDate(date: NSDate) -> Bool {
        if self.compare(date) == .OrderedAscending {
            return true
        } else {
            return false
        }
    }
    
    /**
     Whether self date is earlier than another date
     
     - parameter date: another date to compare
     
     - returns: true if self is earlier than another date, otherwise, false.
     */
    public func isBeforeDate(date: NSDate) -> Bool {
        return isEarlierThanDate(date)
    }
    
    /**
     Whether self date is later than another date
     
     - parameter date: another date to compare
     
     - returns: true if self is later than another date, otherwise, false.
     */
    public func isLaterThanDate(date: NSDate) -> Bool {
        if self.compare(date) == .OrderedDescending {
            return true
        } else {
            return false
        }
    }
    
    /**
     Whether self date is later than another date
     
     - parameter date: another date to compare
     
     - returns: true if self is later than another date, otherwise, false.
     */
    public func isAfterDate(date: NSDate) -> Bool {
        return isLaterThanDate(date)
    }
}

/**
left date is earlier than right date

- parameter lhs: left date
- parameter rhs: right date

- returns: return true if left date is earlier than right date
*/
public func < (lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.isBeforeDate(rhs)
}

/**
left date is equal to right date

- parameter lhs: left date
- parameter rhs: right date

- returns: return true if left date points to same time of right date
*/
public func == (lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.compare(rhs) == .OrderedSame
}

// MARK: - Manipulate date
public extension NSDate {
    // MARK: - Use time interval to set unit
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
    
    // MARK: - Use calendar to set unit
    private static func theCalendar(calendar: NSCalendar?) -> NSCalendar {
        let theCalendar: NSCalendar
        if let calendar = calendar {
            theCalendar = calendar
        } else {
            theCalendar = NSCalendar.gregorianCalendar()
        }
        return theCalendar
    }
    
    public func dateByAddingUnit(unit: NSCalendarUnit, valuesToAdd: Int, calendar: NSCalendar? = nil) -> NSDate? {
        let theCalendar = NSDate.theCalendar(calendar)
        let components = theCalendar.components(unit, fromDate: self)
        
        switch unit {
        case NSCalendarUnit.Era:
            components.era = valuesToAdd
            
        case NSCalendarUnit.Year:
            components.year = valuesToAdd
            
        case NSCalendarUnit.Month:
            components.month = valuesToAdd
            
        case NSCalendarUnit.Day:
            components.day = valuesToAdd
            
        case NSCalendarUnit.Hour:
            components.hour = valuesToAdd
            
        case NSCalendarUnit.Minute:
            components.minute = valuesToAdd
            
        case NSCalendarUnit.Second:
            components.second = valuesToAdd
            
        case NSCalendarUnit.Nanosecond:
            components.nanosecond = valuesToAdd
            
        case NSCalendarUnit.Weekday:
            components.weekday = valuesToAdd
            
        default:
            NSLog("Error: unsupported unit: \(unit)")
            break
        }
        
        return theCalendar.dateByAddingComponents(components, toDate: self, options: [])
    }
    
    public func dateByAddingYears(yearsToAdd: Int, calendar: NSCalendar? = nil) -> NSDate? {
        return dateByAddingUnit(.Year, valuesToAdd: yearsToAdd, calendar: calendar)
    }
    
    public func dateByAddingMonths(monthsToAdd: Int, calendar: NSCalendar? = nil) -> NSDate? {
        return dateByAddingUnit(.Month, valuesToAdd: monthsToAdd, calendar: calendar)
    }
    
    public func dateByAddingDays(daysToAdd: Int, calendar: NSCalendar? = nil) -> NSDate {
        guard let date = dateByAddingUnit(.Day, valuesToAdd: daysToAdd, calendar: calendar) else {
            NSLog("Error: adding days failed, same date is returned")
            return self
        }
        return date
    }
    
    public func dateByAddingHours(hoursToAdd: Int, calendar: NSCalendar? = nil) -> NSDate {
        guard let date = dateByAddingUnit(.Hour, valuesToAdd: hoursToAdd, calendar: calendar) else {
            NSLog("Error: adding hours failed, same date is returned")
            return self
        }
        return date
    }
    
    public func dateByAddingMinutes(minutesToAdd: Int, calendar: NSCalendar? = nil) -> NSDate {
        guard let date = dateByAddingUnit(.Minute, valuesToAdd: minutesToAdd, calendar: calendar) else {
            NSLog("Error: adding minutes failed, same date is returned")
            return self
        }
        return date
    }
    
    public func dateByAddingSeconds(secondsToAdd: Int, calendar: NSCalendar? = nil) -> NSDate {
        guard let date = dateByAddingUnit(.Second, valuesToAdd: secondsToAdd, calendar: calendar) else {
            NSLog("Error: adding seconds failed, same date is returned")
            return self
        }
        return date
    }
}



// MARK: - Get components from date
public extension NSDate {
    // year
    public var year: Int {
        return yearInCalendar(NSCalendar.gregorianCalendar())
    }
    
    public func yearInCalendar(calendar: NSCalendar, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.components(.Year, fromDate: self).year
    }
    
    // month
    public var month: Int {
        return monthInCalendar(NSCalendar.gregorianCalendar())
    }
    
    public func monthInCalendar(calendar: NSCalendar, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.components(.Month, fromDate: self).month
    }
    
    // day
    public var day: Int {
        return dayInCalendar(NSCalendar.gregorianCalendar())
    }
    
    public func dayInCalendar(calendar: NSCalendar, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.components(.Day, fromDate: self).day
    }
    
    // hour
    public var hour: Int {
        return hourInCalendar(NSCalendar.gregorianCalendar())
    }
    
    public func hourInCalendar(calendar: NSCalendar, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.components(.Hour, fromDate: self).hour
    }
    
    // minute
    public var minute: Int {
        return minuteInCalendar(NSCalendar.gregorianCalendar())
    }
    
    public func minuteInCalendar(calendar: NSCalendar, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.components(.Minute, fromDate: self).minute
    }
    
    // second
    public var second: Int {
        return secondInCalendar(NSCalendar.gregorianCalendar())
    }
    
    public func secondInCalendar(calendar: NSCalendar, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.components(.Second, fromDate: self).second
    }
    
    // nanosecond
    public var nanosecond: Int {
        return nanosecondInCalendar(NSCalendar.gregorianCalendar())
    }
    
    public func nanosecondInCalendar(calendar: NSCalendar, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.components(.Nanosecond, fromDate: self).nanosecond
    }
    
    // weekday
    public var weekday: Int {
        return weekdayInCalendar(NSCalendar.gregorianCalendar())
    }
    
    public func weekdayInCalendar(calendar: NSCalendar, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        return calendar.components(.Weekday, fromDate: self).weekday
    }
}


public extension NSDate {
    public class func dateWithYear(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, nanosecond: Int = 0, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        let calendar = calendar ?? NSCalendar.gregorianCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Nanosecond], fromDate: NSDate())
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond
        
        return calendar.dateFromComponents(components)
    }
    
    public func dateBySettingUnit(unit: NSCalendarUnit, newValue: Int, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        
        let calendar = calendar ?? NSCalendar.gregorianCalendar()
        var year = yearInCalendar(calendar, inTimeZone: timeZone)
        var month = monthInCalendar(calendar, inTimeZone: timeZone)
        var day = dayInCalendar(calendar, inTimeZone: timeZone)
        var hour = hourInCalendar(calendar, inTimeZone: timeZone)
        var minute = minuteInCalendar(calendar, inTimeZone: timeZone)
        var second = secondInCalendar(calendar, inTimeZone: timeZone)
        var nanosecond = nanosecondInCalendar(calendar, inTimeZone: timeZone)
        
        switch unit {
        case NSCalendarUnit.Year:
            year = newValue
            
        case NSCalendarUnit.Month:
            month = newValue
            
        case NSCalendarUnit.Day:
            day = newValue
            
        case NSCalendarUnit.Hour:
            hour = newValue
            
        case NSCalendarUnit.Minute:
            minute = newValue
            
        case NSCalendarUnit.Second:
            second = newValue
            
        case NSCalendarUnit.Nanosecond:
            nanosecond = newValue
            
        default:
            NSLog("Error: unsupported unit: \(unit)")
            break
        }
        
        return NSDate.dateWithYear(year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond, inTimeZone: timeZone, calendar: calendar)
    }
    
    public func dateBySettingYear(year: Int, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        return dateBySettingUnit(.Year, newValue: year, inTimeZone: timeZone, calendar: calendar)
    }
    
    public func dateBySettingMonth(month: Int, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        return dateBySettingUnit(.Month, newValue: month, inTimeZone: timeZone, calendar: calendar)
    }
    
    public func dateBySettingDay(day: Int, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        return dateBySettingUnit(.Day, newValue: day, inTimeZone: timeZone, calendar: calendar)
    }
    
    public func dateBySettingHour(hour: Int, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        return dateBySettingUnit(.Hour, newValue: hour, inTimeZone: timeZone, calendar: calendar)
    }
    
    public func dateBySettingMinute(minute: Int, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        return dateBySettingUnit(.Minute, newValue: minute, inTimeZone: timeZone, calendar: calendar)
    }
    
    public func dateBySettingSecond(second: Int, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        return dateBySettingUnit(.Second, newValue: second, inTimeZone: timeZone, calendar: calendar)
    }
    
    public func dateBySettingNanosecond(nanosecond: Int, inTimeZone timeZone: NSTimeZone? = nil, calendar: NSCalendar? = nil) -> NSDate? {
        return dateBySettingUnit(.Nanosecond, newValue: nanosecond, inTimeZone: timeZone, calendar: calendar)
    }
}
