//
//  DispatchQueue+Once.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-11-14.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation

public extension DispatchQueue {
	private static var _onceTracker = Set<String>()
	
	/**
	Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
	only execute the code once even in the presence of multithreaded calls.
	
	- parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
	- parameter block: Block to execute once
	*/
	public class func once(token: String, block: (Void)->Void) {
		objc_sync_enter(self)
		defer {
			objc_sync_exit(self)
		}
		
		if _onceTracker.contains(token) {
			return
		}
		
		_onceTracker.insert(token)
		block()
	}
}
