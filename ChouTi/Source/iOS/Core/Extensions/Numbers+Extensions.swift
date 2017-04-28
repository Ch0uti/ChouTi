//
//  Numbers+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-05.
//

import Foundation

public extension Comparable {
    /**
     Normalize a number to a range
     E.g. 5.normalize(1, 6) will get 5,
     5.normalize(1, 3) will get 3,
     5.normalize(6, 9) will get 6
     
     - parameter min: min number
     - parameter max: max number
     
     - returns: number normalized in this range, if self is in the range, self is returned. otherwirse, it will return min or max.
     */
    public func normalize(_ min: Self, _ max: Self) -> Self {
        guard min <= max else {
            fatalError("Error: min: \(min) is greater than max: \(max)")
        }
        return Swift.min(Swift.max(min, self), max)
    }
	
	/**
	Normalize a number to a range in place.
	
	- parameter min: min number
	- parameter max: max number
	*/
	public mutating func normalizeInPlace(_ min: Self, _ max: Self) {
		guard min <= max else {
			fatalError("Error: min: \(min) is greater than max: \(max)")
		}
		self = Swift.min(Swift.max(min, self), max)
	}
}

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
    public static func random(_ range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
    
    /**
     Get a random integer
     
     - parameter lower: lower number, inclusive
     - parameter upper: upper number, inclusive
     
     - returns: a random integer
     */
    public static func random(_ lower: Int = 0, _ upper: Int = 100) -> Int {
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
    
    /// Return weekday string (0 - Sunday, 1 - Monday, ...)
    public var weekdayString: String? {
        switch self {
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

public extension Double {
    /**
     Get a random Double number
     
     - parameter lower: lower number, inclusive
     - parameter upper: upper number, inclusive
     
     - returns: a random number
     */
    public static func random(_ lower: Double = 0, _ upper: Double = 100) -> Double {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
    
    /// Get a dispatchTime from double number
    public var dispatchTime: DispatchTime {
        get {
            return DispatchTime.now() + Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
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
    public static func random(_ lower: Float = 0, _ upper: Float = 100) -> Float {
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
    public static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
    }
    
    /**
     Get radians from degrees
     
     - returns: radians
     */
    public func toRadians() -> CGFloat {
        return CGFloat.pi / 180 * self
    }
    
    /**
     Get degrees from radians
     
     - returns: degrees
     */
    public func toDegrees() -> CGFloat {
        return 180 / CGFloat.pi * self
    }
    
    /**
     Get a safe multuplier for NSLayoutConstraint
     
     - returns: a safe multipler, which is not zero
     */
    public func safeConstraintMulpilter() -> CGFloat {
        return Swift.max(CGFloat(0.0001), self)
    }
    
    /**
     Normalize a number, which will limit into 0...1
     */
    public func normalize() -> CGFloat {
        return self.normalize(0, 1)
    }
    
    /**
     Normalize a number in place, which will limit into 0...1
     */
    public mutating func normalizeInPlace() {
        self.normalizeInPlace(0, 1)
    }
    
    /**
     Get a number to another number with a percentage
     Example: self is 0.5, right number is 1.0, percentage is 50%, the result will be 0.75
     
     - parameter rightNumber: right number
     - parameter percent:     distance in percentage to right number
     
     - returns: new number
     */
    public func toNumber(_ rightNumber: CGFloat, withPercent percent: CGFloat) -> CGFloat {
        var span = rightNumber - self
        span *= percent
        return self + span
    }
}
