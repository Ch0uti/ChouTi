//
//  File.swift
//  
//
//  Created by Honghao Zhang on 2/12/20.
//

import Foundation

public extension OperationQueue {
	convenience init(name: String) {
		self.init()
		self.name = name
	}

	func addTask(_ task: Operation) {
		self.addOperation(task)
	}
}

public extension Operation {
	func add(to queue: OperationQueue) {
		queue.addOperation(self)
	}
}
