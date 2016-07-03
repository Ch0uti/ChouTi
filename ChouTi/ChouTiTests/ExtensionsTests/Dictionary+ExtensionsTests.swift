//
//  Dictionary+ExtensionsTests.swift
//  ChouTi_FrameworkTests
//
//  Created by Honghao Zhang on 2016-01-28.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import XCTest
@testable import ChouTi

class Dictionary_ExtensionsTests: ChouTiTests {
    
    var dict1 = ["1" : 1, "2" : 2, "3" : 5, "5" : 155]
    let dict2 = ["3" : 3, "4" : 4, "5" : 5]
    let mergedDict = ["1" : 1, "2" : 2, "3" : 3, "4" : 4, "5" : 5]
    
    override func setUp() {
        super.setUp()
    }
    
    func testMergeTwoDictionaries() {
        XCTAssertEqual(dict1 + dict2, mergedDict)
    }
    
    func testMergeTwoDictionariesRightIsNil() {
        let dict2: [String : Int]? = nil
        XCTAssertEqual(dict1 + dict2, dict1)
    }
    
    func testMutateMergeTwoDictionaries() {
        dict1 += dict2
        XCTAssertEqual(dict1, mergedDict)
    }
    
    func testMutateMergeTwoDictionariesRightIsNil() {
        let dict2: [String : Int]? = nil
        dict1 += dict2
        XCTAssertEqual(dict1, dict1)
    }
}

extension Dictionary_ExtensionsTests {
    func testMerge() {
        XCTAssertEqual(dict1.merge(dict2), mergedDict)
    }
    
    func testMergeInPlace() {
        dict1.mergeInPlace(dict2)
        XCTAssertEqual(dict1, mergedDict)
    }
    
    func testDictionaryInitWithAnotherDictionary() {
        XCTAssertEqual(Dictionary(dict2), dict2)
    }
    
    func testMapValues() {
        let result = dict1.mapValues { Int(pow(Double($0), 2)) }
        let expectedDict = ["1" : 1 * 1, "2" : 2 * 2, "3" : 5 * 5, "5" : 155 * 155]
        
        XCTAssertEqual(result, expectedDict)
    }
}
