// Copyright © 2020 ChouTi. All rights reserved.

import Foundation
import XCTest
@testable import ChouTi

class SyncPipeOperationTests: XCTestCase {
  private let queue = OperationQueue()

  func testOutputTask() {
    let generateNumber = OutputTask(defaultOutput: 10) { 20 }
    generateNumber.completionBlock = { [weak generateNumber] in
      XCTAssertEqual(generateNumber?.output, 20)
    }
    XCTAssertEqual(generateNumber.output, 10)
    queue.addOperation(generateNumber)
  }

  func testInputTask() {
    let generateNumber = OutputTask(defaultOutput: 10) { 20 }
    queue.addOperation(generateNumber)

    let acceptNumber = InputTask(dependencyTask: generateNumber) { input in
      XCTAssertEqual(input, 20)
    }
    acceptNumber.addDependency(generateNumber)
    queue.addOperation(acceptNumber)
  }

  func testPipeTask() {
    let generateNumber = OutputTask(defaultOutput: 10) { 20 }
    queue.addOperation(generateNumber)

    let processNumber = PipeTask(dependencyTask: generateNumber, defaultOutput: 0) { input in
      XCTAssertEqual(input, 20)
      return input + 10
    }
    processNumber.addDependency(generateNumber)
    XCTAssertEqual(processNumber.output, 0)
    queue.addOperation(processNumber)

    let acceptNumber = InputTask(dependencyTask: processNumber) { input in
      XCTAssertEqual(input, 30)
    }
    acceptNumber.addDependency(processNumber)
    queue.addOperation(acceptNumber)
  }
}

class AsyncPipeOperationTests: XCTestCase {
  private let queue = OperationQueue()

  func testOutputOnlyTask() {
    let generateNumber = AsyncOutputTask(defaultOutput: 10) { finish in
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
        finish(20)
      }
    }
    queue.addOperation(generateNumber)

    XCTAssertEqual(generateNumber.output, 10)
    Thread.sleep(forTimeInterval: 0.3)
    XCTAssertEqual(generateNumber.output, 20)
  }

  func testInputOnlyTask1() {
    struct GenerateNumber: OutputTaskType {
      let output: Int = 10
    }
    let generateNumber = GenerateNumber()
    let acceptNumber = AsyncInputTask(dependencyTask: generateNumber) { number, finish in
      XCTAssertEqual(number, 10)
      finish()
    }

    queue.addOperation(acceptNumber)
  }

  func testInputOnlyTask2() {
    let generateNumber = AsyncOutputTask(defaultOutput: 10) { finish in
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
        finish(20)
      }
    }
    queue.addOperation(generateNumber)

    let acceptNumber = AsyncInputTask(dependencyTask: generateNumber) { number, finish in
      XCTAssertEqual(number, 20)
      finish()
    }
    acceptNumber.addDependency(generateNumber)

    queue.addOperation(acceptNumber)
  }

  func testPipeTask1() {
    let generateNumber = AsyncOutputTask(defaultOutput: 10) { finish in
      finish(20)
    }
    queue.addOperation(generateNumber)

    let processNumber = AsyncPipeOperation(dependencyTask: generateNumber, defaultOutput: 0) { input, finish in
      XCTAssertEqual(input, 20)
      finish(30)
    }
    processNumber.addDependency(generateNumber)
    queue.addOperation(processNumber)

    XCTAssertEqual(processNumber.output, 0)
    Thread.sleep(forTimeInterval: 0.01)
    XCTAssertEqual(processNumber.output, 30)
  }

  func testPipeTask2() {
    let generateNumber = AsyncOutputTask(defaultOutput: 10) { finish in
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
        finish(20)
      }
    }
    queue.addOperation(generateNumber)

    let processNumber = AsyncPipeOperation(dependencyTask: generateNumber, defaultOutput: 0) { input, finish in
      XCTAssertEqual(input, 20)
      DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
        finish(30)
      }
    }
    processNumber.addDependency(generateNumber)
    queue.addOperation(processNumber)

    XCTAssertEqual(processNumber.output, 0)
    Thread.sleep(forTimeInterval: 0.02)
    XCTAssertEqual(processNumber.output, 0)
    Thread.sleep(forTimeInterval: 0.15)
    XCTAssertEqual(processNumber.output, 0)
    Thread.sleep(forTimeInterval: 0.25)
    XCTAssertEqual(processNumber.output, 30)
  }
}
