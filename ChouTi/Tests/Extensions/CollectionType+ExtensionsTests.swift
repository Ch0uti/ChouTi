//
//  CollectionType+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

@testable import ChouTi
import XCTest

class CollectionType_ExtensionsTests: XCTestCase {

    var integers: [Int] = []

    override func setUp() {
        super.setUp()

        integers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    }

    func testRandomItem() {
        let randomInt = integers.randomElement()!
        XCTAssert(integers.contains(randomInt))

        let randomInt1 = integers.randomElement()!
        var randomInt2 = integers.randomElement()!
        while randomInt2 == randomInt1 {
            randomInt2 = integers.randomElement()!
        }

        XCTAssert(true)
    }

    func testDictionaryRandomItem() {
        let dict = [1: "1", 2: "2", 3: "3", 4: "4"]
        let randomKeyValue = dict.randomElement()!

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
        empty.shuffle()
        XCTAssertEqual(empty, [])

        let originalIntegers = integers
        integers.shuffle()
        XCTAssertNotEqual(originalIntegers, integers)
    }

    func testShuffled() {
        XCTAssertNotEqual(integers, integers.shuffled())
    }
}
