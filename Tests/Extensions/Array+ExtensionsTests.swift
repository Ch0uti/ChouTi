// Copyright © 2020 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class Array_ExtensionsTests: XCTestCase {
  func testRemovingDuplicates() {
    var integers = [1, 2, 2, 1, 3, 4, 5, 3, 4, 5]
    XCTAssertEqual(integers.removingDuplicates(), [1, 2, 3, 4, 5])

    XCTAssertEqual(integers, [1, 2, 2, 1, 3, 4, 5, 3, 4, 5])
    integers.removeDuplicates()
    XCTAssertEqual(integers, [1, 2, 3, 4, 5])
  }
}
