// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class UIView_GeometryTests: XCTestCase {
    let view = UIView()

    override func setUp() {
        super.setUp()

        view.frame = CGRect(x: 100, y: 200, width: 300, height: 400)
    }

    func testWidth() {
        XCTAssertEqual(view.width, 300)

        view.width = 1000
        XCTAssertEqual(view.width, 1000)
        XCTAssertEqual(view.x, 100 - (1000 - 300) / 2.0)
        XCTAssertEqual(view.right, 100 + 300 + (1000 - 300) / 2.0)

        XCTAssertEqual(view.y, 200)
        XCTAssertEqual(view.height, 400)
    }

    func testHeight() {
        XCTAssertEqual(view.height, 400)

        view.height = 1000

        XCTAssertEqual(view.x, 100)
        XCTAssertEqual(view.y, 200 - (1000 - 400) / 2.0)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 1000)
    }

    func testSize() {
        XCTAssertEqual(view.size, CGSize(width: 300, height: 400))

        view.size = CGSize(width: 500, height: 700)

        XCTAssertEqual(view.x, 100 - (500 - 300) / 2.0)
        XCTAssertEqual(view.y, 200 - (700 - 400) / 2.0)
        XCTAssertEqual(view.width, 500)
        XCTAssertEqual(view.height, 700)
    }

    func testX() {
        XCTAssertEqual(view.x, 100)

        view.x = 1000

        XCTAssertEqual(view.x, 1000)
        XCTAssertEqual(view.y, 200)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }

    func testY() {
        XCTAssertEqual(view.y, 200)

        view.y = 1000

        XCTAssertEqual(view.x, 100)
        XCTAssertEqual(view.y, 1000)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }

    func testTop() {
        XCTAssertEqual(view.top, 200)

        view.top = 1000
        XCTAssertEqual(view.x, 100)
        XCTAssertEqual(view.y, 1000)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }

    func testBottom() {
        XCTAssertEqual(view.bottom, 200 + 400)

        view.bottom = 1000

        XCTAssertEqual(view.x, 100)
        XCTAssertEqual(view.y, 1000 - 400)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }

    func testLeft() {
        XCTAssertEqual(view.left, 100)

        view.left = 1000

        XCTAssertEqual(view.x, 1000)
        XCTAssertEqual(view.y, 200)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }

    func testRight() {
        XCTAssertEqual(view.right, 100 + 300)

        view.right = 1000

        XCTAssertEqual(view.x, 1000 - 300)
        XCTAssertEqual(view.y, 200)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }
}

class UIViewLeftToRight_GeometryTests: UIView_GeometryTests {
    override func setUp() {
        super.setUp()

        view.semanticContentAttribute = .forceLeftToRight
    }

    func testLeading() {
        XCTAssertEqual(view.leading, view.left)

        view.leading = 1000

        XCTAssertEqual(view.x, 1000)
        XCTAssertEqual(view.y, 200)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }

    func testTrailing() {
        XCTAssertEqual(view.trailing, view.right)

        view.trailing = 1000

        XCTAssertEqual(view.x, 1000 - 300)
        XCTAssertEqual(view.y, 200)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }
}

class UIViewRightToLeft_GeometryTests: UIView_GeometryTests {
    override func setUp() {
        super.setUp()

        view.semanticContentAttribute = .forceRightToLeft
    }

    func testLeading() {
        XCTAssertEqual(view.leading, view.right)

        view.leading = 1000

        XCTAssertEqual(view.x, 1000 - 300)
        XCTAssertEqual(view.y, 200)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }

    func testTrailing() {
        XCTAssertEqual(view.trailing, view.left)

        view.trailing = 1000

        XCTAssertEqual(view.x, 1000)
        XCTAssertEqual(view.y, 200)
        XCTAssertEqual(view.width, 300)
        XCTAssertEqual(view.height, 400)
    }
}
