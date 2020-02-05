//
//  File.swift
//  
//
//  Created by Honghao Zhang on 2/5/20.
//

import Foundation
import Nimble
import Quick
@testable import ChouTi

class Data_ExtensionsTests: QuickSpec {
  override func spec() {
    it("should get a correct string") {
			let data = "foobar😂".data(using: .utf8)!
			expect(data.string(encoding: .utf8)) == "foobar😂"
			expect(data.string(encoding: .ascii)) == "foobarð"
		}
  }
}
