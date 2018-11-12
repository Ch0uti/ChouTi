//
//  Created by Honghao Zhang on 11/14/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
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
    public class func once(token: String, block: () -> Void) {
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
