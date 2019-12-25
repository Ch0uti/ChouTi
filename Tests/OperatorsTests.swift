// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class OperatorsTests: XCTestCase {
  func testOptionalAssignmentOperator1() {
    var num: Int = 0
    var newNum: Int?
    num =? newNum
    XCTAssertEqual(num, 0)

    newNum = 10
    num =? newNum
    XCTAssertEqual(num, 10)
  }

  func testOptionalAssignmentOperator2() {
    var num: Int?
    var newNum: Int?
    num =? newNum
    XCTAssertEqual(num, nil)

    newNum = 10
    num =? newNum
    XCTAssertEqual(num, 10)
  }

  func testOptionalStringCoalescingOperator() {
    let isNumber: Int? = 99
    XCTAssertEqual("\(isNumber ??? "No Number")", "99")

    let isNil: Int? = nil
    XCTAssertEqual("\(isNil ??? "No Number")", "No Number")
  }
}
