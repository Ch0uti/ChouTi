//
//  QueueTests.swift
//
//  Created by Kåre Morstøl on 11/07/14.
//  Copyright (c) 2014 NotTooBad Software. All rights reserved.
//

import XCTest
@testable import ChouTi

class QueueTests: XCTestCase {
    
    func testAdd1ToQueue() {
        let sut = Queue<String>()
        sut.enqueue("1")
    }
    
    func testAddSeveralToQueue() {
        let sut = Queue<String>()
        XCTAssert(sut.isEmpty())
        sut.enqueue("1")
        sut.enqueue("1")
        XCTAssertFalse(sut.isEmpty())
        sut.enqueue("1")
        sut.enqueue("1")
        sut.enqueue("1")
    }
    
    func testRemoveOne() {
        let sut = Queue<String>()
        sut.enqueue("1")
        sut.enqueue("")
        sut.enqueue("")
        sut.enqueue("")
        let thefirstone = sut.dequeue()
        
        XCTAssertNotNil(thefirstone)
        XCTAssertEqual(thefirstone!, "1")
    }
    
    func testRemoveAll() {
        let sut = Queue<String>()
        sut.enqueue("1")
        sut.enqueue("2")
        sut.enqueue("3")
        sut.enqueue("4")
        
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssertEqual(sut.dequeue()!, "2")
        XCTAssertEqual(sut.dequeue()!, "3")
        XCTAssertEqual(sut.dequeue()!, "4")
        XCTAssert(sut.isEmpty())
        XCTAssertNil(sut.dequeue())
        XCTAssertNil(sut.dequeue())
        XCTAssert(sut.isEmpty())
    }
    
    func testGenerics() {
        let sut = Queue<Int>()
        sut.enqueue(1)
        sut.enqueue(2)
        sut.enqueue(3)
        sut.enqueue(4)
        
        XCTAssertEqual(sut.dequeue()!, 1)
        XCTAssertEqual(sut.dequeue()!, 2)
        XCTAssertEqual(sut.dequeue()!, 3)
        XCTAssertEqual(sut.dequeue()!, 4)
    }
    
    func testAddNil() {
        let sut = Queue<Int?>()
        sut.enqueue(nil)
        XCTAssertNil(sut.dequeue()!)
        
        sut.enqueue(2)
        sut.enqueue(nil)
        sut.enqueue(4)
        
        XCTAssertEqual(sut.dequeue()!!, 2)
        XCTAssertNil(sut.dequeue()!)
        XCTAssertEqual(sut.dequeue()!!, 4)
    }
    
    func testAddAfterEmpty() {
        let sut = Queue<String>()
        
        sut.enqueue("1")
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssertNil(sut.dequeue())
        
        sut.enqueue("1")
        sut.enqueue("2")
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssertEqual(sut.dequeue()!, "2")
        XCTAssert(sut.isEmpty())
        XCTAssertNil(sut.dequeue())
    }
    
    func testAddAndRemoveChaotically() {
        let sut = Queue<String>()
        
        sut.enqueue("1")
        XCTAssertFalse(sut.isEmpty())
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssert(sut.isEmpty())
        XCTAssertNil(sut.dequeue())
        
        sut.enqueue("1")
        sut.enqueue("2")
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssertEqual(sut.dequeue()!, "2")
        XCTAssert(sut.isEmpty())
        XCTAssertNil(sut.dequeue())
        
        sut.enqueue("1")
        sut.enqueue("2")
        XCTAssertEqual(sut.dequeue()!, "1")
        sut.enqueue("3")
        sut.enqueue("4")
        XCTAssertEqual(sut.dequeue()!, "2")
        XCTAssertEqual(sut.dequeue()!, "3")
        XCTAssertFalse(sut.isEmpty())
        XCTAssertEqual(sut.dequeue()!, "4")
        XCTAssertNil(sut.dequeue())
        XCTAssertNil(sut.dequeue())
    }
    
    func testConcurrency() {
        let sut = Queue<Int>()
        let numberofiterations = 2_000_00
        
        let addingexpectation = expectationWithDescription("adding completed")
        let addingqueue = dispatch_queue_create( "adding", DISPATCH_QUEUE_SERIAL)
        dispatch_async(addingqueue)  {
            for i in  1...numberofiterations {
                sut.enqueue(i)
            }
            addingexpectation.fulfill()
        }
        
        let deletingexpectation = expectationWithDescription("deleting completed")
        let deletingqueue = dispatch_queue_create( "deleting", DISPATCH_QUEUE_SERIAL)
        dispatch_async(deletingqueue)  {
            for i in 1...numberofiterations {
                if let result = sut.dequeue() {
                    XCTAssertEqual(result, i)
                } else {
                    print("pausing deleting for one second")
                    sleep(CUnsignedInt(1))
                }
            }
            deletingexpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(600, handler: nil)
    } 
}
