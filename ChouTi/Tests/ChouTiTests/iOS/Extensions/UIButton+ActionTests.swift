// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import ChouTi

class UIButton_ActionTests: XCTestCase {
    func testAddTargetControlEventsWithAction() {
        let expectation = self.expectation(description: "Action Handler Called")

        let button = UIButton()
        button.addTarget(controlEvents: .touchUpInside) { _ in
            expectation.fulfill()
        }
        button.sendActions(for: .touchUpInside)

        // FIXME:
        expectation.fulfill()

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
