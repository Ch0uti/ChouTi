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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCombineTwoDictionaries() {
        let dict1 = ["1" : 1, "2" : 2]
        let dict2 = ["3" : 3, "4" : 4]
        let expectedDict = ["1" : 1, "2" : 2, "3" : 3, "4" : 4]
        
        XCTAssertEqual(dict1 + dict2, expectedDict)
    }
    
    func testCombineTwoDictionariesKeyExisted() {
        let dict1 = ["1" : 1, "2" : 2, "3" : 5, "5" : 155]
        let dict2 = ["3" : 3, "4" : 4, "5" : 5]
        let expectedDict = ["1" : 1, "2" : 2, "3" : 3, "4" : 4, "5" : 5]
        
        XCTAssertEqual(dict1 + dict2, expectedDict)
    }
    
    func testCombineTwoDictionariesRightIsNil() {
        let dict1 = ["1" : 1, "2" : 2, "3" : 5]
        let dict2: [String : Int]? = nil
        let expectedDict = dict1
        
        XCTAssertEqual(dict1 + dict2, expectedDict)
    }
    
    func testMutateCombineTwoDictionaries() {
        var dict1 = ["1" : 1, "2" : 2]
        let dict2 = ["3" : 3, "4" : 4]
        dict1 += dict2
        let expectedDict = ["1" : 1, "2" : 2, "3" : 3, "4" : 4]
        
        XCTAssertEqual(dict1, expectedDict)
    }
    
    func testMutateCombineTwoDictionariesKeyExisted() {
        var dict1 = ["1" : 1, "2" : 2, "3" : 5, "5" : 155]
        let dict2 = ["3" : 3, "4" : 4, "5" : 5]
        dict1 += dict2
        let expectedDict = ["1" : 1, "2" : 2, "3" : 3, "4" : 4, "5" : 5]
        
        XCTAssertEqual(dict1, expectedDict)
    }
    
    func testMutateCombineTwoDictionariesRightIsNil() {
        var dict1 = ["1" : 1, "2" : 2, "3" : 5]
        let dict2: [String : Int]? = nil
        dict1 += dict2
        let expectedDict = dict1
        
        XCTAssertEqual(dict1, expectedDict)
    }
}
