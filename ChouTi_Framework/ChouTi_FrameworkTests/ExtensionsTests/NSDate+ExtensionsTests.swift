//
//  NSDate+ExtensionsTests.swift
//  ChouTi_FrameworkTests
//
//  Created by Honghao Zhang on 2015-12-13.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import ChouTi_Framework

class NSDate_ExtensionsTests: ChouTi_FrameworkTests {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testDateComparison() {
		XCTAssertTrue(NSDate().isEarlierThanDate(NSDate(timeIntervalSinceNow: 20)))
	}
	
	func testForSettingUnit() {
		let date = NSDate()
		let dateWithUpdatedYear = date.dateBySettingUnit(.Year, newValue: 1900)
		XCTAssertEqual(dateWithUpdatedYear?.year, 1900)
	}
}