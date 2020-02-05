// Copyright © 2020 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class CGRect_ExtensionsTests: XCTestCase {
  var frame: CGRect!

  override func setUp() {
    super.setUp()

    frame = CGRect(x: 100, y: 200, width: 300, height: 400)
  }

  func testX() {
    XCTAssertEqual(frame.x, 100)

    frame.x = 1000
    XCTAssertEqual(frame.x, 1000)
    XCTAssertEqual(frame.right, 1000 + 300)

    XCTAssertEqual(frame.y, 200)
    XCTAssertEqual(frame.width, 300)
    XCTAssertEqual(frame.height, 400)
  }

  func testY() {
    XCTAssertEqual(frame.y, 200)

    frame.y = 1000
    XCTAssertEqual(frame.y, 1000)
    XCTAssertEqual(frame.bottom, 1000 + 400)

    XCTAssertEqual(frame.x, 100)
    XCTAssertEqual(frame.width, 300)
    XCTAssertEqual(frame.height, 400)
  }

  func testTop() {
    XCTAssertEqual(frame.top, 200)

    frame.top = 1000
    XCTAssertEqual(frame.top, 1000)
    XCTAssertEqual(frame.bottom, 1000 + 400)

    XCTAssertEqual(frame.width, 300)
    XCTAssertEqual(frame.height, 400)
  }

  func testBottom() {
    XCTAssertEqual(frame.bottom, 200 + 400)

    frame.bottom = 1000
    XCTAssertEqual(frame.bottom, 1000)
    XCTAssertEqual(frame.top, 1000 - 400)

    frame.bottom = 100
    XCTAssertEqual(frame.bottom, 100)
    XCTAssertEqual(frame.top, 100 - 400)

    XCTAssertEqual(frame.width, 300)
    XCTAssertEqual(frame.height, 400)
  }

  func testLeft() {
    XCTAssertEqual(frame.left, 100)

    frame.left = 1000
    XCTAssertEqual(frame.left, 1000)
    XCTAssertEqual(frame.right, 1000 + 300)

    XCTAssertEqual(frame.width, 300)
    XCTAssertEqual(frame.height, 400)
  }

  func testRight() {
    XCTAssertEqual(frame.right, 100 + 300)

    frame.right = 1000
    XCTAssertEqual(frame.right, 1000)
    XCTAssertEqual(frame.left, 1000 - 300)

    XCTAssertEqual(frame.width, 300)
    XCTAssertEqual(frame.height, 400)
  }

  func testUpperLeft() {
    XCTAssertEqual(frame.upperLeft, CGPoint(x: 100, y: 200))
  }

  func testUpperRight() {
    XCTAssertEqual(frame.upperRight, CGPoint(x: 100 + 300, y: 200))
  }

  func testBottomLeft() {
    XCTAssertEqual(frame.bottomLeft, CGPoint(x: 100, y: 200 + 400))
  }

  func testBottomRight() {
    XCTAssertEqual(frame.bottomRight, CGPoint(x: 100 + 300, y: 200 + 400))
  }

  func testCenter() {
    XCTAssertEqual(frame.center, CGPoint(x: 100 + 300 / 2, y: 200 + 400 / 2))

    frame.center = CGPoint(x: 150, y: 200)
    XCTAssertEqual(frame.origin, CGPoint.zero)
    XCTAssertEqual(frame.width, 300)
    XCTAssertEqual(frame.height, 400)
  }
}
