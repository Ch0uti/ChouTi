//
//  NSDate+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-13.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

class NSDate_ExtensionsTests: XCTestCase {

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testForSettingUnit() {
		let date = Date()
		let dateWithUpdatedYear = date.date(bySetting: .year, with: 1_900)
		XCTAssertEqual(dateWithUpdatedYear?.year, 1_900)
	}
}
