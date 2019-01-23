//
//  Created by Honghao Zhang on 7/2/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

class CGRect_ExtensionsTests: XCTestCase {

    var frame: CGRect!

    override func setUp() {
        super.setUp()

        frame = CGRect(x: 100, y: 200, width: 300, height: 400)
    }

    func testX() {
        XCTAssertEqual(frame.x, 100)

        frame.x = 1_000
        XCTAssertEqual(frame.x, 1_000)
        XCTAssertEqual(frame.right, 1_000 + 300)

        XCTAssertEqual(frame.y, 200)
        XCTAssertEqual(frame.width, 300)
        XCTAssertEqual(frame.height, 400)
    }

    func testY() {
        XCTAssertEqual(frame.y, 200)

        frame.y = 1_000
        XCTAssertEqual(frame.y, 1_000)
        XCTAssertEqual(frame.bottom, 1_000 + 400)

        XCTAssertEqual(frame.x, 100)
        XCTAssertEqual(frame.width, 300)
        XCTAssertEqual(frame.height, 400)
    }

    func testTop() {
        XCTAssertEqual(frame.top, 200)

        frame.top = 1_000
        XCTAssertEqual(frame.top, 1_000)
        XCTAssertEqual(frame.bottom, 1_000 + 400)

        XCTAssertEqual(frame.width, 300)
        XCTAssertEqual(frame.height, 400)
    }

    func testBottom() {
        XCTAssertEqual(frame.bottom, 200 + 400)

        frame.bottom = 1_000
        XCTAssertEqual(frame.bottom, 1_000)
        XCTAssertEqual(frame.top, 1_000 - 400)

        frame.bottom = 100
        XCTAssertEqual(frame.bottom, 100)
        XCTAssertEqual(frame.top, 100 - 400)

        XCTAssertEqual(frame.width, 300)
        XCTAssertEqual(frame.height, 400)
    }

    func testLeft() {
        XCTAssertEqual(frame.left, 100)

        frame.left = 1_000
        XCTAssertEqual(frame.left, 1_000)
        XCTAssertEqual(frame.right, 1_000 + 300)

        XCTAssertEqual(frame.width, 300)
        XCTAssertEqual(frame.height, 400)
    }

    func testRight() {
        XCTAssertEqual(frame.right, 100 + 300)

        frame.right = 1_000
        XCTAssertEqual(frame.right, 1_000)
        XCTAssertEqual(frame.left, 1_000 - 300)

        XCTAssertEqual(frame.width, 300)
        XCTAssertEqual(frame.height, 400)
    }
}
