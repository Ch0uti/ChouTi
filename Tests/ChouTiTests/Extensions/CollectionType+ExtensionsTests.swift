// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class CollectionType_ExtensionsTests: XCTestCase {
    var integers: [Int] = []

    override func setUp() {
        super.setUp()

        integers = [1, 2, 3, 4, 5]
    }

    func testSafeSubscript() {
        XCTAssertEqual(integers[safe: -1], nil)
        XCTAssertEqual(integers[safe: 0], 1)
        XCTAssertEqual(integers[safe: 2], 3)
        XCTAssertEqual(integers[safe: 5], nil)
    }
}
