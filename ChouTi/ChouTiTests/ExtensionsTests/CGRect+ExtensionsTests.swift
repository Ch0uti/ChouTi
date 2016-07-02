//
//  CGRect+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest
@testable import ChouTi

class CGRect_ExtensionsTests: ChouTiTests {
    
    var frame: CGRect!
    
    override func setUp() {
        super.setUp()
        frame = CGRect(x: 100, y: 200, width: 300, height: 400)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testX() {
        XCTAssertEqual(frame.x, 100)
    }
    
    func testY() {
        XCTAssertEqual(frame.y, 200)
    }
    
    func testTop() {
        XCTAssertEqual(frame.top, 200)
    }
    
    func testBottom() {
        XCTAssertEqual(frame.bottom, 200 + 400)
    }
    
    func testLeft() {
        XCTAssertEqual(frame.left, 100)
    }
    
    func testRight() {
        XCTAssertEqual(frame.right, 100 + 300)
    }
}
