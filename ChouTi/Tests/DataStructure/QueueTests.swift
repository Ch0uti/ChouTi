//
//  Created by Honghao Zhang on 08/14/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

// Ref: https://gist.github.com/kareman/931017634606b7f7b9c0

@testable import ChouTi
import XCTest

class QueueTests: XCTestCase {

    func testAdd1ToQueue() {
        let q = Queue<String>()
        q.enqueue("1")
    }

    func testAddSeveralToQueue() {
        let q = Queue<String>()
        XCTAssert(q.isEmpty())
        q.enqueue("1")
        q.enqueue("1")
        XCTAssertFalse(q.isEmpty())
        q.enqueue("1")
        q.enqueue("1")
        q.enqueue("1")
    }

    func testRemoveOne() {
        let q = Queue<String>()
        q.enqueue("1")
        q.enqueue("")
        q.enqueue("")
        q.enqueue("")
        let thefirstone = q.dequeue()

        XCTAssertNotNil(thefirstone)
        XCTAssertEqual(thefirstone!, "1")
    }

    func testRemoveAll() {
        let q = Queue<String>()
        q.enqueue("1")
        q.enqueue("2")
        q.enqueue("3")
        q.enqueue("4")

        XCTAssertEqual(q.dequeue()!, "1")
        XCTAssertEqual(q.dequeue()!, "2")
        XCTAssertEqual(q.dequeue()!, "3")
        XCTAssertEqual(q.dequeue()!, "4")
        XCTAssert(q.isEmpty())
        XCTAssertNil(q.dequeue())
        XCTAssertNil(q.dequeue())
        XCTAssert(q.isEmpty())
    }

    func testGenerics() {
        let q = Queue<Int>()
        q.enqueue(1)
        q.enqueue(2)
        q.enqueue(3)
        q.enqueue(4)

        XCTAssertEqual(q.dequeue()!, 1)
        XCTAssertEqual(q.dequeue()!, 2)
        XCTAssertEqual(q.dequeue()!, 3)
        XCTAssertEqual(q.dequeue()!, 4)
    }

    func testAddNil() {
        let q = Queue<Int?>()
        q.enqueue(nil)
        XCTAssertNil(q.dequeue()!)

        q.enqueue(2)
        q.enqueue(nil)
        q.enqueue(4)

        XCTAssertEqual(q.dequeue()!!, 2)
        XCTAssertNil(q.dequeue()!)
        XCTAssertEqual(q.dequeue()!!, 4)
    }

    func testAddAfterEmpty() {
        let q = Queue<String>()

        q.enqueue("1")
        XCTAssertEqual(q.dequeue()!, "1")
        XCTAssertNil(q.dequeue())

        q.enqueue("1")
        q.enqueue("2")
        XCTAssertEqual(q.dequeue()!, "1")
        XCTAssertEqual(q.dequeue()!, "2")
        XCTAssert(q.isEmpty())
        XCTAssertNil(q.dequeue())
    }

    func testAddAndRemoveChaotically() {
        let q = Queue<String>()

        q.enqueue("1")
        XCTAssertFalse(q.isEmpty())
        XCTAssertEqual(q.dequeue()!, "1")
        XCTAssert(q.isEmpty())
        XCTAssertNil(q.dequeue())

        q.enqueue("1")
        q.enqueue("2")
        XCTAssertEqual(q.dequeue()!, "1")
        XCTAssertEqual(q.dequeue()!, "2")
        XCTAssert(q.isEmpty())
        XCTAssertNil(q.dequeue())

        q.enqueue("1")
        q.enqueue("2")
        XCTAssertEqual(q.dequeue()!, "1")
        q.enqueue("3")
        q.enqueue("4")
        XCTAssertEqual(q.dequeue()!, "2")
        XCTAssertEqual(q.dequeue()!, "3")
        XCTAssertFalse(q.isEmpty())
        XCTAssertEqual(q.dequeue()!, "4")
        XCTAssertNil(q.dequeue())
        XCTAssertNil(q.dequeue())
    }
}
