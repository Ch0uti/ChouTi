//
//  String+ExtensionsTests.swift
//  ChouTi_FrameworkTests
//
//  Created by Honghao Zhang on 2015-10-30.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import ChouTi

class String_ExtensionsTest: ChouTiTests {
    
	func testFullNSRange() {
		let string = "123456abc"
		let nsRange = string.fullNSRange()
		XCTAssertEqual(nsRange.location, 0)
		XCTAssertEqual(nsRange.length, 9)
	}
}
