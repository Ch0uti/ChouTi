//
//  ChouTiTests.swift
//  ChouTiTests
//
//  Created by Honghao Zhang on 2015-10-26.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import XCTest
import ChouTi

class ChouTiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//		let string = "123456abc"
//		let nsRange = string.fullNSRange()
//		XCTAssertEqual(nsRange.location, 0)
//		XCTAssertEqual(nsRange.length, 9)
		
		XCTAssertEqual(NSDate().isEarlierThanDate(NSDate()), false)
		
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
