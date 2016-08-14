//
//  NSCalendar+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import Foundation

public extension NSCalendar {
    /// return Gregorian calendar.
    class public func gregorianCalendar() -> NSCalendar? {
        guard let calendar = self.init(identifier: NSCalendarIdentifierGregorian) else {
            NSLog("Error: no calendar \"NSCalendarIdentifierGregorian\" found.")
            return nil
        }
        return calendar
    }
}
