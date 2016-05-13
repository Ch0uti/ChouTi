import UIKit
import XCPlayground

class TestWithLazyProperty {
	private lazy var lazyDictionary: [UInt : UIColor] = { [:] }()
}

sizeof(TestWithLazyProperty)

class TestWithNormalProperty {
	private var lazyDictionary: [UInt : UIColor] = [:]
}

sizeof(TestWithNormalProperty)
