//
//  Utility.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-25.
//

import UIKit

public func delay(seconds seconds: Double, completion: ()->()) {
	let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
	dispatch_after(delayTime, dispatch_get_main_queue()) {
		completion()
	}
}
