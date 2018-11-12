//
//  OperatorsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

class OperatorsTests: XCTestCase {
    func testPowerOperator() {
        XCTAssertEqual(2 ** 3, 8)
        XCTAssertEqual(0 ** 3, 0)
        XCTAssertEqual(1 ** 1, 1)
        XCTAssertEqual(2 ** 0, 1)
        XCTAssertEqual(-1 ** 0, 1)
        XCTAssertEqual(-2 ** 3, (-2) * (-2) * (-2))
        XCTAssertEqual((-2) ** 2, 4)

		XCTAssertEqual(-2 ** 2, (-2) * (-2))
		XCTAssertEqual(1 - 2 ** 2, 1 - 2 * 2)
		XCTAssertEqual(-2 ** 2 * 3, ((-2) * (-2)) * 3)

        XCTAssertEqual(-2 ** 3, (-2) * (-2) * (-2))
        XCTAssertEqual(-(2 ** 3), -8)
		XCTAssertEqual(2 ** 0.5, sqrt(2))
        XCTAssertTrue((-2.0 ** 3.2).isNaN)
    }

	func testOptionalStringCoalescingOperator() {
		let isNumber: Int? = 99
		XCTAssertEqual("\(isNumber ??? "No Number")", "99")

		let isNil: Int? = nil
		XCTAssertEqual("\(isNil ??? "No Number")", "No Number")
	}
}
