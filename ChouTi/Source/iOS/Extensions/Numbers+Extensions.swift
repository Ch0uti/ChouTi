//
//  Created by Honghao Zhang on 09/05/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
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
    func normalize(_ min: Self, _ max: Self) -> Self {
        precondition(min <= max, "Error: min: \(min) is greater than max: \(max)")
        return Swift.min(Swift.max(min, self), max)
    }

	/**
	Normalize a number to a range in place.
	
	- parameter min: min number
	- parameter max: max number
	*/
    mutating func normalizeInPlace(_ min: Self, _ max: Self) {
        precondition(min <= max, "Error: min: \(min) is greater than max: \(max)")
		self = Swift.min(Swift.max(min, self), max)
	}

    /// Clamp `value` to the range min...max. This same as `normalize(_:_:)`.
    ///
    /// - Parameter limits: range to clamp
    /// - Returns: a value between min ... max
    func clamp(to limits: ClosedRange<Self>) -> Self {
        return Swift.min(Swift.max(limits.lowerBound, self), limits.upperBound)
    }

    /// Clamp `self` to the range. This same as `normalizeInPlace(_:_:)`.
    ///
    /// - Parameter limits: range to clamp
    mutating func clampInPlace(to limits: ClosedRange<Self>) {
        self = Swift.min(Swift.max(limits.lowerBound, self), limits.upperBound)
    }
}

public extension Int {
    /// Get ordianl number abbreviation
    var ordinalNumberAbbreviation: String {
        var suffix: String = ""
        let ones: Int = self % 10
        let tens: Int = (self / 10) % 10

        if tens == 1 {
            suffix = "th"
        } else if ones == 1 {
            suffix = "st"
        } else if ones == 2 {
            suffix = "nd"
        } else if ones == 3 {
            suffix = "rd"
        } else {
            suffix = "th"
        }

        return "\(self)\(suffix)"
    }

    /// Return weekday string (0 - Sunday, 1 - Monday, ...)
    var weekdayString: String? {
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
    /// Get a dispatchTime from double number
    var dispatchTime: DispatchTime {
        return DispatchTime.now() + Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }
}

public extension CGFloat {
    /**
     Get radians from degrees
     
     - returns: radians
     */
    func toRadians() -> CGFloat {
        return CGFloat.pi / 180 * self
    }

    /**
     Get degrees from radians
     
     - returns: degrees
     */
    func toDegrees() -> CGFloat {
        return 180 / CGFloat.pi * self
    }

    /**
     Get a safe multuplier for NSLayoutConstraint
     
     - returns: a safe multipler, which is not zero
     */
    func safeConstraintMulpilter() -> CGFloat {
        return Swift.max(CGFloat(0.000_1), self)
    }

    /**
     Normalize a number, which will limit into 0...1
     */
    func normalize() -> CGFloat {
        return self.normalize(0, 1)
    }

    /**
     Normalize a number in place, which will limit into 0...1
     */
    mutating func normalizeInPlace() {
        self.normalizeInPlace(0, 1)
    }
}
