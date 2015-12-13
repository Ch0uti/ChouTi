//
//  NSDate+ExtensionsTests.swift
//  iOS-Example
//
//  Created by Honghao_Zhang on 2015-12-13.
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
	
	func testForYearComponent() {
		XCTAssertEqual(NSDate(timeIntervalSince1970: 100).yearInTimeZone(NSTimeZone(forSecondsFromGMT: 1)), 1970)
	}
}