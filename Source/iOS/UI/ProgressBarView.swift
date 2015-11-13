//
//  ProgressBarView.swift
//  FidoUsage
//
//  Created by Honghao Zhang on 2015-11-02.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

public protocol ProgressBarViewDelegate : class {
	func progressBarView(progressBarView: ProgressBarView, willSetToPercent percent: CGFloat)
	func progressBarView(progressBarView: ProgressBarView, didSetToPercent percent: CGFloat)
}

public class ProgressBarView: UIView {
	
	public var forgroundColor: UIColor = UIColor(white: 0.2, alpha: 1.0) {
		didSet {
			forgroundMeterLayer.backgroundColor = forgroundColor.CGColor
		}
	}
	let forgroundMeterLayer = CAShapeLayer()
	
	public var animationDuration: NSTimeInterval = 1.0
	public var animated: Bool = true
	
	public weak var delegate: ProgressBarViewDelegate?
	
	public var percent: CGFloat = 0.0 {
		didSet {
			precondition(0.0 <= percent && percent <= 1.0, "Percetn must in range 0.0 to 1.0, inclusive.")
			setNeedsLayout()			
			delegate?.progressBarView(self, didSetToPercent: percent)
		}
	}
	
	public func setPercent(percent: CGFloat, animated: Bool = false) {
		self.animated = animated
		self.percent = percent
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		backgroundColor = UIColor(white: 0.9, alpha: 1.0)
		forgroundMeterLayer.backgroundColor = forgroundColor.CGColor
		
		layer.addSublayer(forgroundMeterLayer)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		CATransaction.begin()
		if animated {
			CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
			CATransaction.setAnimationDuration(animationDuration)
			
			forgroundMeterLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width * percent, height: bounds.height)
		} else {
			CATransaction.setDisableActions(true)
			
			forgroundMeterLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width * percent, height: bounds.height)
		}
		
		CATransaction.commit()
		
		layer.cornerRadius = bounds.height / 2.0
		forgroundMeterLayer.cornerRadius = bounds.height / 2.0
	}
}
