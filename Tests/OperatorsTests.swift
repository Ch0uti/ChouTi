// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class OperatorsTests: XCTestCase {
  func testOptionalStringCoalescingOperator() {
    let isNumber: Int? = 99
    XCTAssertEqual("\(isNumber ??? "No Number")", "99")

    let isNil: Int? = nil
    XCTAssertEqual("\(isNil ??? "No Number")", "No Number")
  }
}
