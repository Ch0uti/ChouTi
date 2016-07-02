//
//  OperationsDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-12-18.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi
import Operations

class OperationsDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		multipleTasksDemo()
	}
	
	private func multipleTasksDemo() {
		let queue = OperationQueue()
		
		let operation1 = BlockOperation { (continueWithError: (error: ErrorType?) -> Void) -> Void in
			print("111: started")
			print("1: queue: count: \(queue.operationCount)")
			delay(1) {
				print("111")
				continueWithError(error: nil)
			}
		}
		operation1.completionBlock = {
			print("111: completed")
			print("1: queue: count: \(queue.operationCount)")
		}
		
		let operation2 = BlockOperation { (continueWithError: (error: ErrorType?) -> Void) -> Void in
			print("222: started")
			print("2: queue: count: \(queue.operationCount)")
			delay(2) {
				print("222")
				continueWithError(error: nil)
			}
		}
		operation2.completionBlock = {
			print("222: completed")
			print("2: queue: count: \(queue.operationCount)")
		}
		
		let operation3 = BlockOperation { (continueWithError: (error: ErrorType?) -> Void) -> Void in
			print("333: started")
			print("3: queue: count: \(queue.operationCount)")
			delay(3) {
				print("333")
				continueWithError(error: nil)
			}
		}
		operation3.completionBlock = {
			print("333: completed")
			print("3: queue: count: \(queue.operationCount)")
		}
		
		queue.addOperation(operation1)
		queue.addOperation(operation2)
		queue.addOperation(operation3)
	}
}
