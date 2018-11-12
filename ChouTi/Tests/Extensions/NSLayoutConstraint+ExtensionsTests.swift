//
//  Created by Honghao Zhang on 07/05/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import XCTest

class NSLayoutConstraint_ExtensionsTests: XCTestCase {
    func testActivate() {
        let containerView = UIView()
        let view = UIView()
        containerView.addSubview(view)

        let constraint = view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)

        XCTAssertFalse(constraint.isActive)
        constraint.activate()
        XCTAssertTrue(constraint.isActive)
    }

    func testConstrainToSameLayoutAttributeOnEmpty() {
        let constraints = [].constrainToSame(.width)
        XCTAssertTrue(constraints.isEmpty)
    }

    func testConstrainToSameLayoutAttributeOnCount1() {
        let containerView = UIView()

        let v1 = UIView()
        containerView.addSubview(v1)

        let views = [v1]

        let constraints = views.constrainToSame(.width)
        XCTAssertTrue(constraints.isEmpty)
    }

    func testConstrainToSameLayoutAttributeOnCountTwoAndMore() {
        let containerView = UIView()
        var views: [UIView] = []
        let viewsCount = Int.random(in: 2...10)
        for _ in 0 ..< viewsCount {
            let view = UIView()
            containerView.addSubview(view)
            views.append(view)
        }

        let constraints = views.constrainToSame(.width)
        XCTAssertEqual(constraints.count, viewsCount - 1)

        for (index, constraint) in constraints.enumerated() {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.firstItem as? UIView, views[index])
            XCTAssertEqual(constraint.secondItem as? UIView, views[index + 1])
            XCTAssertEqual(constraint.firstAttribute, NSLayoutConstraint.Attribute.width)
            XCTAssertEqual(constraint.firstAttribute, constraint.secondAttribute)
            XCTAssertEqual(constraint.multiplier, 1.0)
            XCTAssertEqual(constraint.constant, 0.0)
        }
    }
}
