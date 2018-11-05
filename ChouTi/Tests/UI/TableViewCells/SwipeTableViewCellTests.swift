//
//  SwipeTableViewCellTests.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-15.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

@testable import ChouTi
import Nimble
import Quick

class SwipeTableViewCellTests: QuickSpec {
    override func spec() {
        describe("SwipeTableViewCell") {
            var swipeCell: SwipeTableViewCell!

            context("There's no right swipe accessory view") {
                beforeEach {
                    swipeCell = SwipeTableViewCell()
                    swipeCell.rightSwipeAccessoryView = nil
                    swipeCell.setNeedsLayout()
                    swipeCell.layoutIfNeeded()
                }

                it("should expect swipeableContentView have same position and size with contentView") {
                    expect(swipeCell.swipeableContentView.frame) == swipeCell.contentView.bounds
                }

                it("should have no rightSwipeAccessoryView") {
                    expect(swipeCell.rightSwipeAccessoryView).to(beNil())
                }

                it("should have rightSwipeExpanded is false") {
                    expect(swipeCell.rightSwipeExpanded) == false
                }

                it("should keep same frame when expandRightSide") {
                    let originalFrame = swipeCell.swipeableContentView.frame
                    swipeCell.expandRightSide(animated: false)
                    expect(swipeCell.swipeableContentView.frame) == originalFrame
                }

                it("should keep same frame when collapse") {
                    let originalFrame = swipeCell.swipeableContentView.frame
                    swipeCell.collapse(animated: false)
                    expect(swipeCell.swipeableContentView.frame) == originalFrame
                }

                it("should not begin gesture recognizers") {
                    expect(swipeCell.gestureRecognizerShouldBegin(UIGestureRecognizer())).to(beFalse())
                }
            }

            context("There's right swipe accessory view") {
                var rightSwipeAccessoryView: UIView!
                var rightViewWidthConstraint: NSLayoutConstraint!
                var rightViewHeightConstraint: NSLayoutConstraint!

                beforeEach {
                    swipeCell = SwipeTableViewCell()
                    rightSwipeAccessoryView = UIView()
                    rightSwipeAccessoryView.translatesAutoresizingMaskIntoConstraints = false

                    rightViewWidthConstraint = rightSwipeAccessoryView.widthAnchor.constraint(equalToConstant: 0).activate()
                    rightViewHeightConstraint = rightSwipeAccessoryView.heightAnchor.constraint(equalToConstant: 0).activate()

                    swipeCell.rightSwipeAccessoryView = rightSwipeAccessoryView
                    swipeCell.setNeedsLayout()
                    swipeCell.layoutIfNeeded()
                }

                it("should expect swipeableContentView have same position and size with contentView") {
                    expect(swipeCell.swipeableContentView.frame) == swipeCell.contentView.bounds
                }

                it("should have same rightSwipeAccessoryView") {
                    expect(swipeCell.rightSwipeAccessoryView) === rightSwipeAccessoryView
                }

                it("should have rightSwipeExpanded is false") {
                    expect(swipeCell.rightSwipeExpanded) == false
                }

                context("right swipe accessory has zero size") {
                    beforeEach {
                        rightViewWidthConstraint.constant = 0
                        rightViewHeightConstraint.constant = 0
                        swipeCell.setNeedsLayout()
                        swipeCell.layoutIfNeeded()
                    }

                    it("should have swipeableContentView keep same frame and right not expanded when expandRightSide without animation") {
                        let originalFrame = swipeCell.swipeableContentView.frame
                        swipeCell.expandRightSide(animated: false)
                        expect(swipeCell.swipeableContentView.frame) == originalFrame
                        expect(swipeCell.rightSwipeExpanded) == false
                    }

                    it("should have swipeableContentView keep same frame and right not expanded when expandRightSide with animation") {
                        let originalFrame = swipeCell.swipeableContentView.frame
                        swipeCell.expandRightSide(animated: true)
                        expect(swipeCell.swipeableContentView.frame) == originalFrame
                        expect(swipeCell.rightSwipeExpanded) == false
                    }

                    it("should not begin gesture recognizers") {
                        expect(swipeCell.gestureRecognizerShouldBegin(UIGestureRecognizer())).to(beFalse())
                    }

                    context("When in expanded state") {
                        var originalFrame: CGRect!
                        beforeEach {
                            originalFrame = swipeCell.swipeableContentView.frame
                            swipeCell.expandRightSide(animated: false)
                        }

                        it("should have swipeableContentView keep same frame and right not expanded when collapse without animation") {
                            swipeCell.collapse(animated: false)
                            expect(swipeCell.swipeableContentView.frame) == originalFrame
                            expect(swipeCell.rightSwipeExpanded) == false
                        }

                        it("should have swipeableContentView keep same frame and right not expanded when collapse with animation") {
                            swipeCell.collapse(animated: true)
                            expect(swipeCell.swipeableContentView.frame) == originalFrame
                            expect(swipeCell.rightSwipeExpanded) == false
                        }
                    }
                }

                context("right swipe accessory has non-zero size") {
                    beforeEach {
                        rightViewWidthConstraint.constant = 100
                        rightViewHeightConstraint.constant = 40
                        swipeCell.setNeedsLayout()
                        swipeCell.layoutIfNeeded()
                    }

                    it("should have swipeableContentView moved by accessory view width and right expanded at first when expandRightSide without animation") {
                        let originalFrame = swipeCell.swipeableContentView.frame
                        swipeCell.expandRightSide(animated: false)

                        expect(swipeCell.swipeableContentView.frame) == originalFrame.offsetBy(dx: -rightViewWidthConstraint.constant, dy: 0)
                        expect(swipeCell.rightSwipeExpanded).to(beTrue())
                    }

                    it("should have swipeableContentView moved by accessory view width and right not expanded at first but expanded eventually when expandRightSide with animation") {
                        let originalFrame = swipeCell.swipeableContentView.frame
                        swipeCell.expandRightSide(animated: true)

                        expect(swipeCell.swipeableContentView.frame) == originalFrame.offsetBy(dx: -rightViewWidthConstraint.constant, dy: 0)

                        expect(swipeCell.rightSwipeExpanded).to(beTrue())
                        expect(swipeCell.rightSwipeExpanded).toEventually(beTrue())
                    }

                    it("should begin gesture recognizers") {
                        expect(swipeCell.gestureRecognizerShouldBegin(UIGestureRecognizer())).to(beTrue())
                    }

                    context("When in expanded state") {
                        var originalFrame: CGRect!
                        beforeEach {
                            originalFrame = swipeCell.swipeableContentView.frame
                            swipeCell.expandRightSide(animated: false)
                        }

                        it("should have swipeableContentView move to original position and right not expanded at first when collapse without animation") {
                            swipeCell.collapse(animated: false)
                            expect(swipeCell.swipeableContentView.frame) == originalFrame
                            expect(swipeCell.rightSwipeExpanded).to(beFalse())
                        }

                        it("should have swipeableContentView move to original position and right expanded at first but not expanded eventually when collapse with animation") {
                            swipeCell.collapse(animated: true)
                            expect(swipeCell.swipeableContentView.frame) == originalFrame
                            // Expanded at first
                            expect(swipeCell.rightSwipeExpanded).to(beTrue())
                            expect(swipeCell.rightSwipeExpanded).toEventually(beFalse())
                        }

                        it("should collapse animated if prepare for reuse") {
                            swipeCell.prepareForReuse()
                            expect(swipeCell.swipeableContentView.frame) == originalFrame
                            // Expanded at first
                            expect(swipeCell.rightSwipeExpanded).to(beTrue())
                            expect(swipeCell.rightSwipeExpanded).toEventually(beFalse())
                        }

                        it("should collapse animated if willTransitionToState") {
                            swipeCell.willTransition(to: .showingEditControl)
                            expect(swipeCell.swipeableContentView.frame) == originalFrame
                            // Expanded at first
                            expect(swipeCell.rightSwipeExpanded).to(beTrue())
                            expect(swipeCell.rightSwipeExpanded).toEventually(beFalse())
                        }

                        it("should collapse animated if didMoveToWindow") {
                            swipeCell.didMoveToWindow()
                            expect(swipeCell.swipeableContentView.frame) == originalFrame
                            // Expanded at first
                            expect(swipeCell.rightSwipeExpanded).to(beTrue())
                            expect(swipeCell.rightSwipeExpanded).toEventually(beFalse())
                        }
                    }
                }
            }
        }
    }
}
