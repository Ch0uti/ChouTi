//
//  DelayTaskTests.swift
//  ChouTi_Framework
//
//  Created by Honghao Zhang on 2016-02-04.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import ChouTi

class DelayTaskTests: XCTestCase {
    
    func testDelay() {
        let expectation = self.expectation(description: "delayed task executed")
        
        var stringToBeChanged = "start"
        
        let task = delay(0.01) {
            expectation.fulfill()
            stringToBeChanged = "end"
        }
        
        XCTAssertFalse(task.canceled)
        XCTAssertFalse(task.executed)
        XCTAssertEqual(stringToBeChanged, "start")
                
        waitForExpectations(timeout: 0.02) { (error) -> Void in
            XCTAssertFalse(task.canceled)
            XCTAssertTrue(task.executed)
            XCTAssertEqual(stringToBeChanged, "end")
        }
    }
    
    func testDelayCanceledTask() {
        let expectation = self.expectation(description: "delayed task canceled")
        delay(0.02) {
            expectation.fulfill()
        }
        
        var stringToBeChanged = "start"
        
        let task = delay(0.01) {
            stringToBeChanged = "end"
        }
        
        XCTAssertFalse(task.canceled)
        XCTAssertFalse(task.executed)
        XCTAssertEqual(stringToBeChanged, "start")
        
        task.cancel()
        
        XCTAssertTrue(task.canceled)
        
        waitForExpectations(timeout: 0.03) { (error) -> Void in
            XCTAssertTrue(task.canceled)
            XCTAssertFalse(task.executed)
            XCTAssertEqual(stringToBeChanged, "start")
        }
    }
    
    func testDelayCanceledTaskResumed() {
        let expectation = self.expectation(description: "delayed task canceled")
        
        var stringToBeChanged = "start"
        
        let task = delay(0.01) {
            expectation.fulfill()
            stringToBeChanged = "end"
        }
        
        XCTAssertFalse(task.canceled)
        XCTAssertFalse(task.executed)
        XCTAssertEqual(stringToBeChanged, "start")
        
        task.cancel()
        XCTAssertTrue(task.canceled)
        
        task.resume()
        XCTAssertFalse(task.canceled)
        
        waitForExpectations(timeout: 0.02) { (error) -> Void in
            XCTAssertFalse(task.canceled)
            XCTAssertTrue(task.executed)
            XCTAssertEqual(stringToBeChanged, "end")
        }
    }
}
