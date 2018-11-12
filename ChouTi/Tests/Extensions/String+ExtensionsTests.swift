//
//  Created by Honghao Zhang on 10/30/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

class String_ExtensionsTest: XCTestCase {

	func testFullNSRange() {
		let string = "123456abc"
		let nsRange = string.fullNSRange()
		XCTAssertEqual(nsRange.location, 0)
		XCTAssertEqual(nsRange.length, 9)
	}
}
