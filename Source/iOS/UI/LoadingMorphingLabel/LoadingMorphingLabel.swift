//
//  LoadingMorphingLabel.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-11.
//
//

import Foundation
import LTMorphingLabel

public class LoadingMorphingLabel: UIView {
	
	public var loopCount: Int = 10 {
		didSet {
			_loopCount = loopCount
		}
	}
	private var _loopCount: Int = 10
	public var delayDuration: NSTimeInterval = 2.0
	public var texts = [String]()
	public let morphingLabel = LTMorphingLabel()
	
	private var currentTextIndex: Int = 0
	
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
		morphingLabel.centerInSuperview()
		
		texts = ["123", "456", "Foo", "Bar"]
	}
	
	public func startLoop() {
		_loopCount = loopCount
		showTextIndex(currentTextIndex)
	}
	
	public func ednLoop() {
		_loopCount = 0
	}
	
	private func showTextIndex(index: Int) {
		if _loopCount-- > 0 {
			morphingLabel.text = texts[currentTextIndex % texts.count]
			delay(seconds: delayDuration, completion: {
				self.showTextIndex(++self.currentTextIndex)
			})
		}
	}
	
	public override func didMoveToWindow() {
		super.didMoveToWindow()
		startLoop()
	}
}
