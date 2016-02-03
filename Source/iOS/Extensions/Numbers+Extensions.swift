//
//  Numbers+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-05.
//

import Foundation

public extension Bool {
    /**
     Get a random boolean value
     
     - returns: a random boolean value
     */
    public static func random() -> Bool {
        return Int.random() % 2 == 0
    }
}

public extension Int {
    /**
     Get a random integer from a range
     
     - parameter range: range for the random number
     
     - returns: a random integer
     */
    public static func random(range: Range<Int>) -> Int {
        return range.startIndex + Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex)))
    }
    
    /**
     Get a random integer
     
     - parameter lower: lower number, inclusive
     - parameter upper: upper number, inclusive
     
     - returns: a random integer
     */
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}

public extension Int {
    /// Get ordianl number abbreviation
    public var ordinalNumberAbbreviation: String {
        var suffix: String = ""
        let ones: Int = self % 10
        let tens: Int = (self / 10) % 10
        
        if (tens == 1) {
            suffix = "th"
        } else if (ones == 1) {
            suffix = "st"
        } else if (ones == 2) {
            suffix = "nd"
        } else if (ones == 3) {
            suffix = "rd"
        } else {
            suffix = "th"
        }
        
        return "\(self)\(suffix)"
    }
}

public extension Double {
    /**
     Get a random Double number
     
     - parameter lower: lower number, inclusive
     - parameter upper: upper number, inclusive
     
     - returns: a random number
     */
    public static func random(lower: Double = 0, _ upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
    /// Get a dispatchTime from double number
    public var dispatchTime: dispatch_time_t {
        get {
            return dispatch_time(DISPATCH_TIME_NOW,Int64(self * Double(NSEC_PER_SEC)))
        }
    }
}

public extension Float {
    /**
     Get a random Float number
     
     - parameter lower: lower number, inclusive
     - parameter upper: upper number, inclusive
     
     - returns: a random number
     */
    public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

public extension CGFloat {
    /**
     Get a random CGFloat number
     
     - parameter lower: lower number, inclusive
     - parameter upper: upper number, inclusive
     
     - returns: a random number
     */
    public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
    
    /// Get a radian degree
    public var radianDegree: CGFloat {
        return CGFloat(M_PI / 180) * self
    }
    
    /**
     Get a safe multuplier for NSLayoutConstraint
     
     - returns: a safe multipler, which is not zero
     */
    public func safeMulpilter() -> CGFloat {
        return Swift.max(CGFloat(0.0001), self)
    }
    
    /**
     Normalize a number, which will limit into 0...1
     */
    public mutating func normalize() {
        self = Swift.min( Swift.max(CGFloat(0), self), CGFloat(1))
    }
    
    /**
     Get a number to another number with a percentage
     Example: self is 0.5, right number is 1.0, percentage is 50%, the result will be 0.75
     
     - parameter rightNumber: right number
     - parameter percent:     distance in percentage to right number
     
     - returns: new number
     */
    public func toNumber(rightNumber: CGFloat, withPercent percent: CGFloat) -> CGFloat {
        var span = rightNumber - self
        span *= percent
        return self + span
    }
}
