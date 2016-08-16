//
//  CollectionType+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest
@testable import ChouTi

class CollectionType_ExtensionsTests: XCTestCase {
    
    var integers: [Int] = []
    
    override func setUp() {
        super.setUp()
        integers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    }
    
    func testRandomItem() {
        let randomInt = integers.randomItem()
        XCTAssert(integers.contains(randomInt))
        
        let randomInt1 = integers.randomItem()
        var randomInt2 = integers.randomItem()
        while randomInt2 == randomInt1 {
            randomInt2 = integers.randomItem()
        }
        
        XCTAssert(true)
    }
    
    func testDictionaryRandomItem() {
        let dict = [1: "1", 2: "2", 3: "3", 4: "4"]
        let randomKeyValue = dict.randomItem()
        
        XCTAssertTrue(dict.contains { $0 == randomKeyValue })
    }
}

extension CollectionType_ExtensionsTests {
    func testSafeSubscript() {
        XCTAssertEqual(integers[safe: 0], 1)
        XCTAssertEqual(integers[safe: 10], nil)
    }
}

extension CollectionType_ExtensionsTests {
    func testShuffleInPlace() {
        var empty: [Int] = []
        empty.shuffleInPlace()
        XCTAssertEqual(empty, [])
        
        let originalIntegers = integers
        integers.shuffleInPlace()
        XCTAssertNotEqual(originalIntegers, integers)
    }
    
    func testShuffle() {
        XCTAssertNotEqual(integers, integers.shuffle())
    }
}
