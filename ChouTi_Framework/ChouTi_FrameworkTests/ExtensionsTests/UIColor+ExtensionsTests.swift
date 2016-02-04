//
//  UIColor+ExtensionsTests.swift
//  ChouTi_FrameworkTests
//
//  Created by Honghao Zhang on 2016-01-28.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import ChouTi_Framework

class UIColor_ExtensionsTests: ChouTi_FrameworkTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHexColor() {
        let color = UIColor(hexString: "#CC0000")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.hexString, "#CC0000")
    }
}
