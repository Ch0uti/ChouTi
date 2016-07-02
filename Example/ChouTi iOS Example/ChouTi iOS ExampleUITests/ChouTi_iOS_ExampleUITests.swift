//
//  ChouTi_iOS_ExampleUITests.swift
//  ChouTi iOS ExampleUITests
//
//  Created by Honghao Zhang on 2016-06-29.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest

class ChouTi_iOS_ExampleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTitle() {
        let app = XCUIApplication()
        XCTAssert(app.navigationBars["🗄 抽屉(ChouTi)"].staticTexts["🗄 抽屉(ChouTi)"].exists)
    }
}
