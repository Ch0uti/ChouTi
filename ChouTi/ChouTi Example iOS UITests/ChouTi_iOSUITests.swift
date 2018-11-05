//
//  ChouTi_iOSUITests.swift
//  ChouTi iOSUITests
//
//  Created by Honghao Zhang on 2016-08-13.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest

class ChouTi_iOSUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTitle() {
        let app = XCUIApplication()
        XCTAssert(app.navigationBars["🗄 抽屉(ChouTi)"].exists)
    }

    func testExample() {
		XCTAssertFalse(app.tables.cells.staticTexts["123"].exists)
        XCTAssertTrue(XCUIApplication().tables.cells.staticTexts["TableViewCell Selection Action Test"].exists)

        //		tableviewcellSelectionActionTestStaticText.tap()
        //
        //		XCUIApplication().tables.cells.staticTexts["TableViewCell Selection Action Test"].tap()
        //		XCUIApplication().tables.staticTexts["TableViewCell Selection Action Test"].tap()

        //        let nextGame = app.tables.staticTexts["123"]
        //        let exists = NSPredicate(format: "exists == true")
        //        expectationForPredicate(exists, evaluatedWithObject: nextGame, handler: nil)
        //
        ////        app.buttons["Load More Games"].tap()
        ////        app.tables.cells.staticTexts["TableViewCell Selection Action Test"].tap()
        //
        //        let tableviewcellSelectionActionTestStaticText = XCUIApplication().tables.cells.staticTexts["TableViewCell Selection Action Test"]
        //        tableviewcellSelectionActionTestStaticText.pressForDuration(0.5);
        //
        //        waitForExpectationsWithTimeout(3, handler: nil)
        //        XCTAssert(nextGameLabel.exists)

        //        XCTAssertTrue(nextGame.exists)
    }
}
