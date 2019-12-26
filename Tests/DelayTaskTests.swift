// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class DelayTaskTests: XCTestCase {
  func testDelay() {
    let expectation = self.expectation(description: "delayed task executed")

    var stringToBeChanged = "start"

    // Task is retained in the expectation closure.
    let task = delay(0.05) {
      XCTAssertTrue(!Thread.isMainThread)
      expectation.fulfill()
      stringToBeChanged = "end"
    }

    XCTAssertFalse(task.isCanceled)
    XCTAssertFalse(task.isExecuted)
    XCTAssertEqual(stringToBeChanged, "start")

    waitForExpectations(timeout: 0.06) { _ in
      XCTAssertFalse(task.isCanceled)
      XCTAssertTrue(task.isExecuted)
      XCTAssertEqual(stringToBeChanged, "end")
    }
  }

  func testSimpleDelay() {
    let expectation = self.expectation(description: "delayed task executed")

    var stringToBeChanged = "start"

    // No retain
    delay(0.05) {
      expectation.fulfill()
      stringToBeChanged = "end"
    }

    XCTAssertEqual(stringToBeChanged, "start")
    waitForExpectations(timeout: 0.06) { _ in
      XCTAssertEqual(stringToBeChanged, "end")
    }
  }

  func testSimpleDelayOnMain() {
    let expectation = self.expectation(description: "delayed task executed")

    var stringToBeChanged = "start"

    // No retain
    delay(0.05, queue: .main) {
      XCTAssertTrue(Thread.isMainThread)
      expectation.fulfill()
      stringToBeChanged = "end"
    }

    XCTAssertEqual(stringToBeChanged, "start")
    waitForExpectations(timeout: 0.06) { _ in
      XCTAssertEqual(stringToBeChanged, "end")
    }
  }

  func testCanceledTask() {
    var stringToBeChanged = "start"
    let task = delay(0.05) {
      stringToBeChanged = "end"
    }

    XCTAssertFalse(task.isCanceled)
    XCTAssertFalse(task.isExecuted)
    XCTAssertEqual(stringToBeChanged, "start")

    task.isCanceled = true
    XCTAssertTrue(task.isCanceled)

    Thread.sleep(forTimeInterval: 0.06)

    XCTAssertTrue(task.isCanceled)
    XCTAssertFalse(task.isExecuted)
    XCTAssertEqual(stringToBeChanged, "start")
  }

  func testChainedTask() {
    var value = 1

    delay(0.2) {
      value = 2
    }
    .delay(0.2) {
      value = 3
    }

    XCTAssertEqual(value, 1)

    Thread.sleep(forTimeInterval: 0.3)
    XCTAssertEqual(value, 2)

    Thread.sleep(forTimeInterval: 0.2)
    XCTAssertEqual(value, 3)
  }
}
