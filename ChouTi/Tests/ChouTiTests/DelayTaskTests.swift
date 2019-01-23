//
//  Created by Honghao Zhang on 2/4/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

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

        waitForExpectations(timeout: 0.02) { _ -> Void in
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

        waitForExpectations(timeout: 0.03) { _ -> Void in
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

        waitForExpectations(timeout: 0.02) { _ -> Void in
            XCTAssertFalse(task.canceled)
            XCTAssertTrue(task.executed)
            XCTAssertEqual(stringToBeChanged, "end")
        }
    }
}
