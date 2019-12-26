// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class Numbers_ExtensionsTests: XCTestCase {
  func testClamp() {
    XCTAssertEqual(120.clamped(to: 0...100), 100)
    XCTAssertEqual(99.clamped(to: 0...100), 99)
    XCTAssertEqual((-20).clamped(to: 0...100), 0)

    var num = 120
    num.clamping(to: 0...100)
    XCTAssertEqual(num, 100)
  }

  func testOrdinalNumberAbbreviation() {
    XCTAssertEqual(1.ordinalNumberAbbreviation, "1st")
    XCTAssertEqual(2.ordinalNumberAbbreviation, "2nd")
    XCTAssertEqual(3.ordinalNumberAbbreviation, "3rd")
    XCTAssertEqual(4.ordinalNumberAbbreviation, "4th")
    XCTAssertEqual(10.ordinalNumberAbbreviation, "10th")
    XCTAssertEqual(11.ordinalNumberAbbreviation, "11th")
    XCTAssertEqual(21.ordinalNumberAbbreviation, "21st")
    XCTAssertEqual(22.ordinalNumberAbbreviation, "22nd")
    XCTAssertEqual(23.ordinalNumberAbbreviation, "23rd")
  }

  func testWeekdayString() {
    XCTAssertEqual(0.weekdayString, "Sunday")
    XCTAssertEqual(1.weekdayString, "Monday")
    XCTAssertEqual(2.weekdayString, "Tuesday")
    XCTAssertEqual(3.weekdayString, "Wednesday")
    XCTAssertEqual(4.weekdayString, "Thursday")
    XCTAssertEqual(5.weekdayString, "Friday")
    XCTAssertEqual(6.weekdayString, "Saturday")
    XCTAssertEqual(7.weekdayString, nil)
  }

  func testDegreeRadian() {
    XCTAssertEqual(CGFloat(180).radian, CGFloat.pi)
    XCTAssertEqual(CGFloat.pi.degree, 180)
  }
}
