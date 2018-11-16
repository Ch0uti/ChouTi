//
//  Created by Honghao Zhang on 08/13/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import Nimble
import Quick

class Calendar_ExtensionsTests: QuickSpec {
    override func spec() {
        describe("Calendar+Extensions") {
            it("should get correct gregorian calendar") {
                expect(Calendar.gregorian.identifier) == Calendar.Identifier.gregorian
            }
        }
    }
}
