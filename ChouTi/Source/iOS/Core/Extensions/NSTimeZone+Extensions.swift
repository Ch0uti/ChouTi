//
//  NSTimeZone+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-13.
//
//

import Foundation

public extension TimeZone {
    /**
     Get GMT time zone, if fails, fall back to `autoupdatingCurrent`
     
     - returns: GMT time zone
     */
    public static func GMT() -> TimeZone {
        guard let gmt = TimeZone(abbreviation: "GMT") else {
            NSLog("Error: time zone with `GMT` abbreviation not found")
            return TimeZone.autoupdatingCurrent
        }
        return gmt
    }
    
    /**
     Get EST time zone, if fails, fall back to `autoupdatingCurrent`
     
     - returns: EST time zone
     */
    public static func EST() -> TimeZone {
        guard let est = TimeZone(abbreviation: "EST") else {
            NSLog("Error: time zone with `EST` abbreviation not found")
            return TimeZone.autoupdatingCurrent
        }
        return est
    }
}
