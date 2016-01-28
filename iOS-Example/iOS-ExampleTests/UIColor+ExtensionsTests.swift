//
//  UIColor+ExtensionsTests.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2016-01-28.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import UIKit
import XCTest
import ChouTi

class UIColor_ExtensionsTests: XCTestCase {
    
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
