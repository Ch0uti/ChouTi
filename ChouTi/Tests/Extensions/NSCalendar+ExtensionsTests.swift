//
//  NSCalendar+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-13.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

@testable import ChouTi
import Nimble
import Quick

class NSCalendar_ExtensionsTests: QuickSpec {
    override func spec() {
        describe("NSCalendar+Extensions") {
            it("should get correct gregorian calendar") {
                expect(Calendar.gregorian.identifier) == Calendar.Identifier.gregorian
            }
        }
    }
}
