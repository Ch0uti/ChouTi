// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class DelayTaskTests: XCTestCase {
  func testDelay() {
    let expectation = self.expectation(description: "delayed task executed")

    var stringToBeChanged = "start"

    // Task is retained in the expectation closure.
    let task = delay(0.01) {
      XCTAssertTrue(!Thread.isMainThread)
      expectation.fulfill()
      stringToBeChanged = "end"
    }

    XCTAssertFalse(task.isCanceled)
    XCTAssertFalse(task.isExecuted)
    XCTAssertEqual(stringToBeChanged, "start")

    waitForExpectations(timeout: 0.011) { _ in
      XCTAssertFalse(task.isCanceled)
      XCTAssertTrue(task.isExecuted)
      XCTAssertEqual(stringToBeChanged, "end")
    }
  }

  func testSimpleDelay() {
    let expectation = self.expectation(description: "delayed task executed")

    var stringToBeChanged = "start"

    // No retain
    delay(0.01) {
      expectation.fulfill()
      stringToBeChanged = "end"
    }

    XCTAssertEqual(stringToBeChanged, "start")
    waitForExpectations(timeout: 0.011) { _ in
      XCTAssertEqual(stringToBeChanged, "end")
    }
  }

  func testSimpleDelayOnMain() {
    let expectation = self.expectation(description: "delayed task executed")

    var stringToBeChanged = "start"

    // No retain
    delay(0.01, queue: .main) {
      XCTAssertTrue(Thread.isMainThread)
      expectation.fulfill()
      stringToBeChanged = "end"
    }

    XCTAssertEqual(stringToBeChanged, "start")
    waitForExpectations(timeout: 0.011) { _ in
      XCTAssertEqual(stringToBeChanged, "end")
    }
  }

  func testCanceledTask() {
    var stringToBeChanged = "start"
    let task = delay(0.01) {
      stringToBeChanged = "end"
    }

    XCTAssertFalse(task.isCanceled)
    XCTAssertFalse(task.isExecuted)
    XCTAssertEqual(stringToBeChanged, "start")

    task.isCanceled = true
    XCTAssertTrue(task.isCanceled)

    Thread.sleep(forTimeInterval: 0.011)

    XCTAssertTrue(task.isCanceled)
    XCTAssertFalse(task.isExecuted)
    XCTAssertEqual(stringToBeChanged, "start")
  }

  func testChainedTask() {
    print(CACurrentMediaTime())
    var value = 1

    delay(0.02) {
      print(CACurrentMediaTime())
      value = 2
    }
    .delay(0.02) {
      print(CACurrentMediaTime())
      value = 3
    }

    XCTAssertEqual(value, 1)

    Thread.sleep(forTimeInterval: 0.025)
    XCTAssertEqual(value, 2)

    Thread.sleep(forTimeInterval: 0.02)
    XCTAssertEqual(value, 3)
  }
}
