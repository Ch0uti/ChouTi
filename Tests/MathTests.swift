// Copyright © 2020 ChouTi. All rights reserved.

import Foundation
import XCTest
@testable import ChouTi

class MathTests: XCTestCase {
  func testLerp() {
    XCTAssertEqual(lerp(start: 0, end: 100, t: 0.5), 50)
    XCTAssertEqual(lerp(start: 10.0, end: 20.0, t: 0.1), 11.0)
  }
}
