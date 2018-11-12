//
//  SeparatorCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-04.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

// FIXME: Height is not settable

open class SeparatorCell: TableViewCell {

	open var separatorView = UIView() {
		didSet {

		}
	}

	override open func commonInit() {
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
			"separatorView": separatorView
		]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[separatorView(0.5)]-|", options: [], metrics: nil, views: views)
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[separatorView]-|", options: [], metrics: nil, views: views)

		NSLayoutConstraint.activate(constraints)
	}
}

extension SeparatorCell {
	override open class func estimatedHeight() -> CGFloat {
		return 0.5
	}
}
