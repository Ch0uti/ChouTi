//
//  NavigationBarStatusBar.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-15.
//
//

import UIKit

public class NavigationBarStatusBar: UIView {
	public let titleLabel = UILabel()
	public var statusBarHeight: CGFloat? {
		didSet {
			if let height = statusBarHeight where height > 0 {
				_heightConstraint.constant = height
				_heightConstraint.active = true
			} else {
				_heightConstraint.active = false
			}
		}
	}
	
	private var _heightConstraint: NSLayoutConstraint!
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		setupViews()
		setupConstraints()
	}

	private func setupViews() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)
		
		titleLabel.textAlignment = .Center
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.font = UIFont.systemFontOfSize(24)
		
		backgroundColor = UIColor(red:79/255.0, green:30/255.0, blue:169/255.0, alpha:255/255.0)
	}

	private func setupConstraints() {
		preservesSuperviewLayoutMargins = false
		layoutMargins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)

		let views = [
			"titleLabel" : titleLabel
		]
		let metrics = [
			"top_min_spacing" : layoutMargins.top,
			"bottom_min_spacing" : layoutMargins.bottom
		]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]-|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=top_min_spacing)-[titleLabel]-(>=bottom_min_spacing)-|", options: [], metrics: metrics, views: views)
		constraints += [NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)]
		
        _heightConstraint = self.constrainTo(height: 44)

		NSLayoutConstraint.activateConstraints(constraints)
	}
}
