//
//  Created by Honghao Zhang on 10/18/2018.
//  Copyright © 2018 ChouTi. All rights reserved.
//

@testable import ChouTi
import Foundation
import Nimble
import Quick

class DispatchQueue_ExtensionsTests: QuickSpec {
    override func spec() {
        describe("dispatch queue on main") {
            context("if dispatch from the main queue") {
                it ("should run async method immediately") {
                    var hasRun = false
                    DispatchQueue.onMainAsync {
                        hasRun = true
                    }
                    expect(hasRun).to(beTrue())
                }

                it ("should run sync method immediately") {
                    var hasRun = false
                    DispatchQueue.onMainSync {
                        hasRun = true
                    }
                    expect(hasRun).to(beTrue())
                }
            }

            context("if dispatch from another queue") {
                it ("should run async method later") {
                    var hasRun = false
                    DispatchQueue(label: "dummy dispatch queue").async {
                        DispatchQueue.onMainAsync {
                            hasRun = true
                        }
                        expect(hasRun).to(beFalse())
                    }
                    expect(hasRun).toEventually(beTrue())
                }

                it ("should still run sync method immediately") {
                    var hasRun = false
                    DispatchQueue(label: "dummy dispatch queue").async {
                        DispatchQueue.onMainSync {
                            hasRun = true
                        }
                        expect(hasRun).to(beTrue())
                    }
                }
            }
        }
    }
}
