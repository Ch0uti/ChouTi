//
//  UIView+ExtensionsTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-12.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import Nimble
import Quick

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
				expect(view.superview(ofType: UIScrollView.self)) === superScrollView
            }

            it("should get correct super view for more than 2 levels") {
                let superScrollView = UIScrollView()
                let superTableView = UITableView()
                superScrollView.addSubview(view)
                superTableView.addSubview(superScrollView)
				expect(view.superview(ofType: UITableView.self)) === superTableView
            }
        }

        describe("UIView subviews") {
            var view: UIView!
            beforeEach {
                view = UIView()
            }

            it("should get nil if there's no subviews") {
                expect(view.subviewOfType(UIScrollView.self)).to(beNil())
            }

            it("should get nil is no such subview of type") {
                view.addSubview(UIView())
                expect(view.subviewOfType(UIScrollView.self)).to(beNil())
            }

            it("should find the subview in one level") {
                view.addSubview(UIView())
                view.addSubview(UIScrollView())
                let tableView = UITableView()
                view.addSubview(tableView)

                expect(view.subviewOfType(UITableView.self)) === tableView
            }

            it("should find the subview in more than 1 level") {
                view.addSubview(UIView())
                let scrollView = UIScrollView()
                view.addSubview(scrollView)
                let tableView = UITableView()
                scrollView.addSubview(tableView)

                expect(view.subviewOfType(UITableView.self)) === tableView
            }

            it("should find the subview in level 1 (in BFS order)") {
                view.addSubview(UIView())
                let scrollView = UIScrollView()
                view.addSubview(scrollView)
                let tableView2 = UITableView()
                scrollView.addSubview(tableView2)
                view.addSubview(UIScrollView())
                let tableView1 = UITableView()
                view.addSubview(tableView1)

                expect(view.subviewOfType(UITableView.self)) === tableView1
            }
        }
    }
}
