//
//  UIView+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-12.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Quick
import Nimble
@testable import ChouTi

class UIView_ExtensionsTests: QuickSpec {
    override func spec() {
        describe("UIView superview") {
            var view: UIView!
            beforeEach {
                view = UIView()
            }
            
            it("should get correct super view") {
                let superScrollView = UIScrollView()
                superScrollView.addSubview(view)
                expect(view.superviewOfType(UIScrollView)) === superScrollView
            }
            
            it("should get correct super view for more than 2 levels") {
                let superScrollView = UIScrollView()
                let superTableView = UITableView()
                superScrollView.addSubview(view)
                superTableView.addSubview(superScrollView)
                expect(view.superviewOfType(UITableView)) === superTableView
            }
        }
    }
}
