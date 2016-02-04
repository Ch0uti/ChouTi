//
//  DelayTaskTests.swift
//  ChouTi_Framework
//
//  Created by Honghao Zhang on 2016-02-04.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import ChouTi_Framework
import ChouTi

class DelayTaskTests: ChouTi_FrameworkTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDelay() {
        let expectation = expectationWithDescription("delayed task executed")
        
        var stringToBeChanged = "start"
        
        let task = delay(2.0) {
            expectation.fulfill()
            stringToBeChanged = "end"
        }
        
        XCTAssertFalse(task.canceled)
        XCTAssertFalse(task.executed)
                
        waitForExpectationsWithTimeout(2.1) { (error) -> Void in
            XCTAssertFalse(task.canceled)
            XCTAssertTrue(task.executed)
            XCTAssertEqual(stringToBeChanged, "end")
        }
    }
    
    func testDelayCanceledTask() {
        let expectation = expectationWithDescription("delayed task canceled")
        delay(2.2) {
            expectation.fulfill()
        }
        
        var stringToBeChanged = "start"
        
        let task = delay(2.0) {
            stringToBeChanged = "end"
        }
        
        XCTAssertFalse(task.canceled)
        XCTAssertFalse(task.executed)
        
        task.cancel()
        
        XCTAssertTrue(task.canceled)
        
        waitForExpectationsWithTimeout(2.4) { (error) -> Void in
            XCTAssertTrue(task.canceled)
            XCTAssertFalse(task.executed)
            XCTAssertEqual(stringToBeChanged, "start")
        }
    }
    
    func testDelayCanceledTaskResumed() {
        let expectation = expectationWithDescription("delayed task canceled")
        
        var stringToBeChanged = "start"
        
        let task = delay(2.0) {
            expectation.fulfill()
            stringToBeChanged = "end"
        }
        
        XCTAssertFalse(task.canceled)
        XCTAssertFalse(task.executed)
        
        task.cancel()
        XCTAssertTrue(task.canceled)
        
        task.resume()
        XCTAssertFalse(task.canceled)
        
        waitForExpectationsWithTimeout(2.1) { (error) -> Void in
            XCTAssertFalse(task.canceled)
            XCTAssertTrue(task.executed)
            XCTAssertEqual(stringToBeChanged, "end")
        }
    }
}
