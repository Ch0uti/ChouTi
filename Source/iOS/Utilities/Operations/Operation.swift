//
//  Operation.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-18.
//
//

import UIKit

class Operation: NSOperation {
	init(operationBlock: Void -> Void, completionBlock: (finished: Bool) -> Void) {
		super.init()
	}
}
