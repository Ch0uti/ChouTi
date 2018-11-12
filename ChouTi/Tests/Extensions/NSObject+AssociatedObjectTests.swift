//
//  NSObject+AssociatedObjectTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-14.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

class NSObject_AssociatedObjectTests: XCTestCase {
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

    private enum TestAssociateObjectKey {
        static var Key = "TestAssociateObjectKey"
    }

    func testAssociatedObjectWithPointer() {
        host.setAssociatedObejct("998", forKeyPointer: &TestAssociateObjectKey.Key)
        XCTAssertEqual(host.setAssociatedObejct(778, forKeyPointer: &TestAssociateObjectKey.Key) as? String, "998")
        XCTAssertEqual(host.clearAssociatedObject(forKeyPointer: &TestAssociateObjectKey.Key) as? Int, 778)
        XCTAssertNil(host.getAssociatedObject(forKeyPointer: &TestAssociateObjectKey.Key))
    }
}
