//
//  UIColor+ExtensionsTests.swift
//  ChouTi_FrameworkTests
//
//  Created by Honghao Zhang on 2016-01-28.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Quick
import Nimble
@testable import ChouTi


class UIColor_ExtensionsTests: QuickSpec {
    override func spec() {
        describe("hex color") {
            it("should get nil if hex string has no # prefix") {
                let color = UIColor(hexString: "CC0000")
                expect(color).to(beNil())
            }
            
            it("should get nil if hex string has incorrect length") {
                let color = UIColor(hexString: "#CC000000")
                expect(color).to(beNil())
            }
            
            it("should create correct color with hex string") {
                let color = UIColor(hexString: "#CC0000")
                expect(color).toNot(beNil())
                expect(color?.hexString) == "#CC0000"
            }
        }
    }
}
