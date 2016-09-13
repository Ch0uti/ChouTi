//
//  NSLayoutConstraint+RetrieveTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-09-09.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Quick
import Nimble
@testable import ChouTi


class NSLayoutConstraint_RetrieveTests: QuickSpec {
    override func spec() {
        describe("NSLayoutConstraint+Retrieve") {
            context("Retrieving constraints meet requirements") {
                var view: UIView!
                beforeEach {
                    view = UIView()
                }
                
                it("should get the correct constraint added") {
                    let view2 = UIView()
                    view.addSubview(view2)
                    let theConstraint = view.leadingAnchor.constrainTo(anchor: view2.leadingAnchor)
                    view2.leadingAnchor.constrainTo(anchor: view.leadingAnchor)
                    
                    let retrievedConstraints = view.constraints(withFirstItem: view, firstAttribute: .Leading, relation: .Equal, secondItem: view2, secondAttribute: .Leading, multiplier: 1.0, constant: 0.0)
                    expect(retrievedConstraints.count) == 1
                    expect(retrievedConstraints.first) === theConstraint
                }
            }
        }
    }
}