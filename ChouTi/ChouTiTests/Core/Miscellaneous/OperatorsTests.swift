//
//  OperatorsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest
@testable import ChouTi

class OperatorsTests: XCTestCase {
    func testPowerOperator() {
        XCTAssertEqual(2 ** 3, 8)
        XCTAssertEqual(0 ** 3, 0)
        XCTAssertEqual(1 ** 1, 1)
        XCTAssertEqual(2 ** 0, 1)
        XCTAssertEqual(-1 ** 0, 1)
        XCTAssertEqual(-2 ** 3, (-2) * (-2) * (-2))
        XCTAssertEqual((-2) ** 2, 4)
        XCTAssertEqual(-2 ** 2 * 3, ((-2) * (-2)) * 3)
        XCTAssertEqual(-2 ** 3, (-2) * (-2) * (-2))
        XCTAssertEqual(-(2 ** 3), -8)
		
        XCTAssertTrue((-2 ** 3.2).isNaN)
    }
}
