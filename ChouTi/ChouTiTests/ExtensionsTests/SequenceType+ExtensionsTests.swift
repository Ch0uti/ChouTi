//
//  SequenceType+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-03.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest
@testable import ChouTi

class SequenceType_ExtensionsTests: ChouTiTests {
    func testRandomSubset() {
        let integers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let empty: [Int] = []
        XCTAssertEqual(empty.randomSubset(), empty)
        
        let subset = integers.randomSubset()
        XCTAssert(0 <= subset.count && subset.count <= integers.count)
    }
    
    func testDictionaryRandomSubset() {
        let dict = [1: "1", 2: "2", 3: "3", 4: "4"]
        let subDict = dict.randomSubDictionary()
        
        XCTAssertTrue(
            subDict.allMatch { (key, value) -> Bool in
                dict.keys.contains(key) && dict[key] == value
            }
        )
    }
    
    func testUnique() {
        let integers = [1, 2, 2, 1, 3, 4, 5, 3, 4, 5,]
        XCTAssertEqual(integers.unique(), [1, 2, 3, 4, 5])
    }
}
