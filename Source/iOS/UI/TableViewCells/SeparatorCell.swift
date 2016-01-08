//
//  SeparatorCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-04.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

// FIXME: Height is not settable

public class SeparatorCell: TableViewCell {

	public var separatorView: UIView = UIView() {
		didSet {
			
		}
	}
	
	override public func commonInit() {
		super.commonInit()
		
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(separatorView)
		separatorView.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		preservesSuperviewLayoutMargins = false
		layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
		
		let views = [
			"separatorView" : separatorView
		]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[separatorView(0.5)]-|", options: [], metrics: nil, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[separatorView]-|", options: [], metrics: nil, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
}

extension SeparatorCell {
	public override class func estimatedRowHeight() -> CGFloat {
		return 0.5
	}
}
