//
//  Created by Honghao Zhang on 01/28/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

class Dictionary_ExtensionsTests: XCTestCase {

    var dict1 = ["1": 1, "2": 2, "3": 5, "5": 155]
    let dict2 = ["3": 3, "4": 4, "5": 5]
    let mergedDict = ["1": 1, "2": 2, "3": 3, "4": 4, "5": 5]

    override func setUp() {
        super.setUp()
    }

    func testMergeTwoDictionaries() {
        XCTAssertEqual(dict1 + dict2, mergedDict)
    }

    func testMergeTwoDictionariesRightIsNil() {
        let dict2: [String: Int]? = nil
        XCTAssertEqual(dict1 + dict2, dict1)
    }

    func testMutateMergeTwoDictionaries() {
        dict1 += dict2
        XCTAssertEqual(dict1, mergedDict)
    }

    func testMutateMergeTwoDictionariesRightIsNil() {
        let dict2: [String: Int]? = nil
        dict1 += dict2
        XCTAssertEqual(dict1, dict1)
    }
}

extension Dictionary_ExtensionsTests {
    func testMerge() {
        XCTAssertEqual(dict1.merge(with: dict2), mergedDict)
    }

    func testMergeInPlace() {
        dict1.merged(with: dict2)
        XCTAssertEqual(dict1, mergedDict)
    }
}
