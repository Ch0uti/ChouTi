//
//  LoadingMorphingLabel.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-11.
//
//

import Foundation
import LTMorphingLabel

/// A label shows a list of text in loop
public class LoadingMorphingLabel: UIView {

	public var loopCount: Int = 10 {
		didSet {
			_loopCount = loopCount
		}
	}
	private var _loopCount: Int = 10

	public var delayDuration: TimeInterval = 2.0
	public var morphingDuration: Float {
		get { return morphingLabel.morphingDuration }
		set { morphingLabel.morphingDuration = newValue }
	}

	public var morphingEffect: LTMorphingEffect {
		get { return morphingLabel.morphingEffect }
		set { morphingLabel.morphingEffect = newValue }
	}

	public var texts = [String]()
	public let morphingLabel = LTMorphingLabel()

	public var currentTextIndex: Int = 0
	private var isAnimating: Bool = false

	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		morphingLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(morphingLabel)
		morphingLabel.constrainToCenterInSuperview()

		texts = ["123", "456", "Foo", "Bar"]
	}

	public func startLoop() {
		_loopCount = loopCount
		if isAnimating { return }
        showTextIndex(currentTextIndex)
	}

	public func endLoop() {
		_loopCount = 0
	}

	private func showTextIndex(_ index: Int) {
		if _loopCount > 0 {
            _loopCount -= 1
			isAnimating = true
			morphingLabel.text = texts[currentTextIndex % texts.count]
            currentTextIndex += 1
			delay(delayDuration) {
				self.showTextIndex(self.currentTextIndex)
			}
		} else {
			isAnimating = false
		}
	}

	public override func didMoveToWindow() {
		super.didMoveToWindow()
		startLoop()
	}
}
