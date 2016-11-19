//
//  CGContext+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-02.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import XCTest
@testable import ChouTi

class CGContext_ExtensionsTests: XCTestCase {
    
    // +-----+
    // |     |
    // |     | 50
    // +-----+
    //
    func testFlipCoordinatesVertically() {
        UIGraphicsBeginImageContext(CGSize(width: 20, height: 50))
        let context = UIGraphicsGetCurrentContext()
        
        let matrix = context!.ctm
		XCTAssertEqual(matrix, CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 50))
        
        context!.concatenate(CGAffineTransform(a: 2, b: 10, c: 10, d: 2, tx: 5, ty: 5))
        let matrix1 = context!.ctm
		
		XCTAssertEqual(matrix1, CGAffineTransform(a: 2, b: -10, c: 10, d: -2, tx: 5, ty: 45))
        
        context?.flipCoordinatesVertically()
        
        let matrix2 = context!.ctm
		
		XCTAssertEqual(matrix2, CGAffineTransform(a: 2, b: -10, c: -10, d: 2, tx: 505, ty: -55))
        
        UIGraphicsEndImageContext()
    }
}
