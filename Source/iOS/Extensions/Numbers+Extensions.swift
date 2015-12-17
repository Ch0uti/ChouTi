//
//  Numbers+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-05.
//

import Foundation

public extension Bool {
	public static func random() -> Bool {
		return Int.random() % 2 == 0
	}
}

public extension Int {
	public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
		return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
	}
	
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
	public var dispatchTime: dispatch_time_t {
		get {
			return dispatch_time(DISPATCH_TIME_NOW,Int64(self * Double(NSEC_PER_SEC)))
		}
	}
	
	public static func random(lower: Double = 0, _ upper: Double = 100) -> Double {
		return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
	}
}

public extension Float {
	public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
		return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
	}
}

public extension CGFloat {
	/// Get a radian degree
	public var radianDegree: CGFloat {
		return CGFloat(M_PI / 180) * self
	}
	
	public static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
		return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
	}
	
	/**
	Get a safe multuplier for NSLayoutConstraint
	
	- returns: a safe multipler, which is not zero
	*/
	public func safeMulpilter() -> CGFloat {
		return Swift.max(CGFloat(0.0001), self)
	}
	
	public mutating func normalize() {
		self = Swift.min( Swift.max(CGFloat(0), self), CGFloat(1))
	}
	
	public func toNumber(rightNumber: CGFloat, withPercent percent: CGFloat) -> CGFloat {
		var span = rightNumber - self
		span *= percent
		return self + span
	}
}
