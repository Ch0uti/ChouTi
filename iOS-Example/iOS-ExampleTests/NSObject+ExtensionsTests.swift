//
//  NSObject+ExtensionsTests.swift
//  iOS-Example
//
//  Created by Honghao_Zhang on 2015-12-14.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import XCTest
import ChouTi

class NSObject_ExtensionsTests: XCTestCase {
	var host: NSObject!
	
	override func setUp() {
		super.setUp()
		host = NSObject()
	}
	
	override func tearDown() {
		super.tearDown()
		host = nil
	}
	
	func testAssociatedObject() {
		let associatedNumber = 123
		host.associatedObject = associatedNumber
		XCTAssertEqual(host.associatedObject as? Int, 123)
		host.associatedObject = nil
		XCTAssertNil(host.associatedObject)
	}
	
	func testGetAssociatedObject() {
		host.setAssociatedObejct("998")
		XCTAssertEqual(host.getAssociatedObject() as? String, "998")
		XCTAssertEqual(host.setAssociatedObejct(778) as? String, "998")
		XCTAssertEqual(host.clearAssociatedObject() as? Int, 778)
		XCTAssertNil(host.getAssociatedObject())
	}
}
