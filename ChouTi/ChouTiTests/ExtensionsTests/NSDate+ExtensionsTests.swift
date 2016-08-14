//
//  NSDate+ExtensionsTests.swift
//  ChouTi_FrameworkTests
//
//  Created by Honghao Zhang on 2015-12-13.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import ChouTi

class NSDate_ExtensionsTests: ChouTiTests {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testDateComparison() {
		XCTAssertTrue(NSDate().isEarlierThanDate(NSDate(timeIntervalSinceNow: 20)))
        XCTAssertTrue(NSDate().isBeforeDate(NSDate(timeIntervalSinceNow: 20)))
        XCTAssertTrue(NSDate() < (NSDate(timeIntervalSinceNow: 20)))
        XCTAssertFalse(NSDate().isEarlierThanDate(NSDate(timeIntervalSinceNow: -20)))
        
        XCTAssertTrue(NSDate().isLaterThanDate(NSDate(timeIntervalSinceNow: -20)))
        XCTAssertTrue(NSDate().isAfterDate(NSDate(timeIntervalSinceNow: -20)))
        XCTAssertFalse(NSDate().isLaterThanDate(NSDate(timeIntervalSinceNow: 20)))
        
        XCTAssertTrue(NSDate(timeIntervalSince1970: 10) == NSDate(timeIntervalSince1970: 10))
	}
	
	func testForSettingUnit() {
		let date = NSDate()
		let dateWithUpdatedYear = date.dateBySettingUnit(.Year, newValue: 1900)
		XCTAssertEqual(dateWithUpdatedYear?.year, 1900)
	}
}
