//
//  OrderedDictionaryTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-11-18.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

@testable import ChouTi
import XCTest

class OrderedDictionaryTests: XCTestCase {
	var dict: OrderedDictionary<String, Int>!

	override func setUp() {
        super.setUp()
		dict = OrderedDictionary<String, Int>()
	}

	func testBasicOperations() {
		XCTAssertNil(dict["none"])

		dict["apple"] = 1
		XCTAssertEqual(dict["apple"], 1)
		XCTAssertEqual(dict[0].0, "apple")
		XCTAssertEqual(dict[0].1, 1)
		XCTAssertEqual(dict.count, 1)

		dict["apple"] = 11
		XCTAssertEqual(dict["apple"], 11)
		XCTAssertEqual(dict[0].0, "apple")
		XCTAssertEqual(dict[0].1, 11)
		XCTAssertEqual(dict.count, 1)

		dict["banana"] = 2
		XCTAssertEqual(dict["banana"], 2)
		XCTAssertEqual(dict[1].0, "banana")
		XCTAssertEqual(dict[1].1, 2)
		XCTAssertEqual(dict.count, 2)

		dict.removeValue(forKey: "apple")
		XCTAssertNil(dict["apple"])
		XCTAssertEqual(dict.count, 1)

		dict.removeAll()
		XCTAssertEqual(dict.count, 0)
	}

	func testInsertionAtIndex() {
		dict["apple"] = 1
		XCTAssertEqual(dict["apple"], 1)
		XCTAssertEqual(dict[0].0, "apple")
		XCTAssertEqual(dict[0].1, 1)
		XCTAssertEqual(dict.count, 1)

		dict.insert(2, forKey: "banana", atIndex: 1)
		XCTAssertEqual(dict["banana"], 2)
		XCTAssertEqual(dict[0].0, "apple")
		XCTAssertEqual(dict[0].1, 1)
		XCTAssertEqual(dict[1].0, "banana")
		XCTAssertEqual(dict[1].1, 2)
		XCTAssertEqual(dict.count, 2)

		dict.insert(3, forKey: "orange", atIndex: 1)
		XCTAssertEqual(dict["orange"], 3)
		XCTAssertEqual(dict[0].0, "apple")
		XCTAssertEqual(dict[0].1, 1)
		XCTAssertEqual(dict[1].0, "orange")
		XCTAssertEqual(dict[1].1, 3)
		XCTAssertEqual(dict[2].0, "banana")
		XCTAssertEqual(dict[2].1, 2)
		XCTAssertEqual(dict.count, 3)

		var newDict = dict!
		newDict.insert(4, forKey: "apple", atIndex: 2)
		XCTAssertEqual(newDict["apple"], 4)
		XCTAssertEqual(newDict[0].0, "orange")
		XCTAssertEqual(newDict[0].1, 3)
		XCTAssertEqual(newDict[1].0, "banana")
		XCTAssertEqual(newDict[1].1, 2)
		XCTAssertEqual(newDict[2].0, "apple")
		XCTAssertEqual(newDict[2].1, 4)
		XCTAssertEqual(newDict.count, 3)

		newDict = dict!
		newDict.insert(4, forKey: "apple", atIndex: 3)
		XCTAssertEqual(newDict["apple"], 4)
		XCTAssertEqual(newDict[0].0, "orange")
		XCTAssertEqual(newDict[0].1, 3)
		XCTAssertEqual(newDict[1].0, "banana")
		XCTAssertEqual(newDict[1].1, 2)
		XCTAssertEqual(newDict[2].0, "apple")
		XCTAssertEqual(newDict[2].1, 4)
		XCTAssertEqual(newDict.count, 3)

		newDict = dict!
		newDict.insert(4, forKey: "apple", atIndex: 1)
		XCTAssertEqual(newDict["apple"], 4)
		XCTAssertEqual(newDict[0].0, "orange")
		XCTAssertEqual(newDict[0].1, 3)
		XCTAssertEqual(newDict[1].0, "apple")
		XCTAssertEqual(newDict[1].1, 4)
		XCTAssertEqual(newDict[2].0, "banana")
		XCTAssertEqual(newDict[2].1, 2)
		XCTAssertEqual(newDict.count, 3)

		let removed = dict.removeAtIndex(1)
		XCTAssertEqual(removed.0, "orange")
		XCTAssertEqual(removed.1, 3)
		XCTAssertEqual(dict[0].0, "apple")
		XCTAssertEqual(dict[0].1, 1)
		XCTAssertEqual(dict[1].0, "banana")
		XCTAssertEqual(dict[1].1, 2)
		XCTAssertEqual(dict.count, 2)
	}
}
