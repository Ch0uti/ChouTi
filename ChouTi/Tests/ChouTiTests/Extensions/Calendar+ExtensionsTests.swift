// Copyright © 2019 ChouTi. All rights reserved.

import Foundation
import Nimble
import Quick
@testable import ChouTi

class Calendar_ExtensionsTests: QuickSpec {
    override func spec() {
        describe("Calendar+Extensions") {
            it("should get correct gregorian calendar") {
                expect(Calendar.gregorian.identifier) == Calendar.Identifier.gregorian
            }
        }
    }
}
