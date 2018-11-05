//
//  SingleTitleContentPairView.swift
//  FidoUsage
//
//  Created by Honghao Zhang on 2015-11-04.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

open class SingleTitleContentPairView: UIView {
	public let titleLabel = UILabel()
	public let contentLabel = UILabel()

	open var horizontalSpacing: CGFloat = 8.0 {
		didSet {
			horizontalSpacingEqualConstraint?.constant = -horizontalSpacing
			horizontalSpacingGreaterThanConstraint?.constant = -horizontalSpacing
		}
	}

	private var horizontalSpacingEqualConstraint: NSLayoutConstraint?
	private var horizontalSpacingGreaterThanConstraint: NSLayoutConstraint?

	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)
		titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
		titleLabel.text = "Title"

		contentLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentLabel)
		contentLabel.font = UIFont.systemFont(ofSize: 14)
		contentLabel.text = "Content"

		setupConstraints()
	}

	private func setupConstraints() {
		let views = [
			"titleLabel": titleLabel,
			"contentLabel": contentLabel
		]

		let metrics = [
			"horizontal_spacing": 8.0
		]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[contentLabel]-|", options: [], metrics: metrics, views: views)
		constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .lastBaseline, relatedBy: .equal, toItem: contentLabel, attribute: .lastBaseline, multiplier: 1.0, constant: 0.0))
		horizontalSpacingEqualConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentLabel, attribute: .leading, multiplier: 1.0, constant: -horizontalSpacing)
		horizontalSpacingEqualConstraint!.priority = UILayoutPriority(750)

		horizontalSpacingGreaterThanConstraint = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: contentLabel, attribute: .leading, multiplier: 1.0, constant: -horizontalSpacing)

		constraints.append(horizontalSpacingEqualConstraint!)
		constraints.append(horizontalSpacingGreaterThanConstraint!)

		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-|", options: [], metrics: metrics, views: views)

		NSLayoutConstraint.activate(constraints)
	}
}
