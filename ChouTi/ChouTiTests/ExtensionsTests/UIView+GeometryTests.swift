//
//  UIView+GeometryTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest
@testable import ChouTi

class UIView_GeometryTests: ChouTiTests {
    let view = UIView()
    override func setUp() {
        super.setUp()
        view.semanticContentAttribute = .ForceLeftToRight
        
        view.frame = CGRect(x: 100, y: 200, width: 300, height: 400)
    }
    
    func testWidth() {
        XCTAssertEqual(view.width, 300)
    }
    
    func testHeight() {
        XCTAssertEqual(view.height, 400)
    }
    
    func testSize() {
        XCTAssertEqual(view.size, CGSize(width: 300, height: 400))
    }
    
    func testX() {
        XCTAssertEqual(view.x, 100)
    }
    
    func testY() {
        XCTAssertEqual(view.y, 200)
    }
    
    func testTop() {
        XCTAssertEqual(view.top, 200)
    }
    
    func testBottom() {
        XCTAssertEqual(view.bottom, 200 + 400)
    }
    
    func testLeft() {
        XCTAssertEqual(view.left, 100)
    }
    
    func testRight() {
        XCTAssertEqual(view.right, 100 + 300)
    }
}

class UIViewLeftToRight_GeometryTests: UIView_GeometryTests {
    override func setUp() {
        super.setUp()
        view.semanticContentAttribute = .ForceLeftToRight
    }
    
    func testLeading() {
        XCTAssertEqual(view.leading, view.left)
    }
    
    func testTrailing() {
        XCTAssertEqual(view.trailing, view.right)
    }
}

class UIViewRightToLeft_GeometryTests: UIView_GeometryTests {
    override func setUp() {
        super.setUp()
        view.semanticContentAttribute = .ForceRightToLeft
    }
    
    func testLeading() {
        XCTAssertEqual(view.leading, view.right)
    }
    
    func testTrailing() {
        XCTAssertEqual(view.trailing, view.left)
    }
}

