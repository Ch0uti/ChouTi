//
//  NSLayoutConstraint+RetrieveTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-09-09.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import Nimble
import Quick

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
                    let theConstraint = view.leadingAnchor.constrain(to: view2.leadingAnchor)
                    view2.leadingAnchor.constrain(to: view.leadingAnchor)

                    let retrievedConstraints = view.constraints(withFirstItem: view, firstAttribute: .leading, relation: .equal, secondItem: view2, secondAttribute: .leading, multiplier: 1.0, constant: 0.0)
                    expect(retrievedConstraints.count) == 1
                    expect(retrievedConstraints.first) === theConstraint
                }
            }
        }
    }
}
