// Copyright © 2020 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class CGPoint_ExtensionsTests: XCTestCase {
  func test() {
    let point = CGPoint(x: 10, y: 20)
    XCTAssertEqual(point.translate(5, dy: 10), CGPoint(x: 15, y: 30))
  }
}
