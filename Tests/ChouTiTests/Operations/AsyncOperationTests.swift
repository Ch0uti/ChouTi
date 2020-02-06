// Copyright © 2020 ChouTi. All rights reserved.

import Foundation
import XCTest
@testable import ChouTi

class AsyncOperationTests: XCTestCase {
  class AddOperation: AsyncOperation {
    private let lhs: Int
    private let rhs: Int
    var result: Int?

    init(lhs: Int, rhs: Int) {
      self.lhs = lhs
      self.rhs = rhs

      super.init()
    }

    override func main() {
      DispatchQueue.global().async {
        // Set to finished when job is done.
        defer {
          self.finish()
        }

        // Long time working.
        Thread.sleep(forTimeInterval: 0.5)

        // Check is it's cancelled.
        guard !self.isCancelled else {
          return
        }

        self.result = self.lhs + self.rhs
      }
    }
  }

  let queue = OperationQueue()

  func testBasic() {
    let expectation = self.expectation(description: "operation finished")

    let op = AddOperation(lhs: 10, rhs: 20)
    XCTAssertTrue(op.isAsynchronous)

    queue.addOperation(op)
    op.completionBlock = {
      expectation.fulfill()
    }

    XCTAssertNil(op.result)

    waitForExpectations(timeout: 0.6) { _ in
      XCTAssertEqual(op.result, 30)
    }
  }

  func testCancelBeforeStart() {
    let op = AddOperation(lhs: 10, rhs: 20)
    XCTAssertEqual(op.state, .ready)
    XCTAssertFalse(op.isCancelled)
    XCTAssertTrue(op.isReady)
    XCTAssertFalse(op.isExecuting)
    XCTAssertFalse(op.isFinished)

    XCTAssertNil(op.result)

    op.cancel()

    XCTAssertEqual(op.state, .ready)
    XCTAssertTrue(op.isCancelled)
    XCTAssertTrue(op.isReady)
    XCTAssertFalse(op.isExecuting)
    XCTAssertFalse(op.isFinished)

    queue.addOperation(op)

    Thread.sleep(forTimeInterval: 0.1)

    XCTAssertEqual(op.state, .finished)
    XCTAssertTrue(op.isCancelled)
    XCTAssertFalse(op.isReady)
    XCTAssertFalse(op.isExecuting)
    XCTAssertTrue(op.isFinished)

    XCTAssertNil(op.result)
  }

  func testStartThenCancel() {
    let op = AddOperation(lhs: 10, rhs: 20)
    queue.addOperation(op)

    Thread.sleep(forTimeInterval: 0.2) // operation starts

    XCTAssertEqual(op.state, .executing)
    XCTAssertFalse(op.isCancelled)
    XCTAssertTrue(op.isReady)
    XCTAssertTrue(op.isExecuting)
    XCTAssertFalse(op.isFinished)

    XCTAssertNil(op.result)

    op.cancel()

    XCTAssertEqual(op.state, .executing)
    XCTAssertTrue(op.isCancelled)
    // Cancel doesn't affect state immediately
    XCTAssertTrue(op.isReady)
    XCTAssertTrue(op.isExecuting)
    XCTAssertFalse(op.isFinished)

    // When operation finally finishes, state should be updated.
    Thread.sleep(forTimeInterval: 0.35) // operation ends
    XCTAssertEqual(op.state, .finished)
    XCTAssertTrue(op.isCancelled)
    XCTAssertFalse(op.isReady)
    XCTAssertFalse(op.isExecuting)
    XCTAssertTrue(op.isFinished)

    XCTAssertNil(op.result)
  }
}
