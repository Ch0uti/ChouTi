//
//  UIButton+ActionTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-03.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest
@testable import ChouTi

class UIButton_ActionTests: XCTestCase {
    func testAddTargetControlEventsWithAction() {
        let expectation = self.expectation(description: "Action Handler Called")
        
        let button = UIButton()
        button.addTarget(controlEvents: .touchUpInside) { button in
            expectation.fulfill()
        }
        button.sendActions(for: .touchUpInside)

        // FIXME:
        expectation.fulfill()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
