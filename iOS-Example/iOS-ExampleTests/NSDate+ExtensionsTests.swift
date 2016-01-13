//
//  NSDate+ExtensionsTests.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-12-13.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import XCTest
import ChouTi

class NSDate_ExtensionsTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testExample() {
		XCTAssertTrue(NSDate().isEarlierThanDate(NSDate(timeIntervalSinceNow: 20)))
	}
	
	func testForComponents() {
		let date = NSDate()
		let dateWithUpdatedYear = date.dateByUpdatingUnit(.Year, newValue: 1900)
		XCTAssertEqual(dateWithUpdatedYear?.year, 1900)
	}
}