//
//  Numbers+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-09-05.
//
//

import Foundation

public extension Double {
	public var dispatchTime: dispatch_time_t {
		get {
			return dispatch_time(DISPATCH_TIME_NOW,Int64(self * Double(NSEC_PER_SEC)))
		}
	}
}

public extension CGFloat {
	/// Get a radian degree
	public var radianDegree: CGFloat {
		return CGFloat(M_PI / 180) * self
	}
}

