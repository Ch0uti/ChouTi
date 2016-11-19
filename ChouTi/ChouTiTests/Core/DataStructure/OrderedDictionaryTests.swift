//
//  OrderedDictionaryTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-11-18.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest
@testable import ChouTi

class OrderedDictionaryTests: XCTestCase {
	var dict: OrderedDictionary<String, Int>!
	
	override func setUp() {
		dict = OrderedDictionary<String, Int>()
	}
	
	func testInsertion() {
		XCTAssertNil(dict["none"])
		
		dict["apple"] = 1
		XCTAssertEqual(dict["apple"], 1)
	}
	
	func testInsertionAtIndex() {
		
	}
}
