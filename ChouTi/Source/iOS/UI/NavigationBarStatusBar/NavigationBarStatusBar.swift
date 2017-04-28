//
//  NavigationBarStatusBar.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-15.
//
//

import UIKit

open class NavigationBarStatusBar: UIView {
	open let titleLabel = UILabel()
	open var statusBarHeight: CGFloat? {
		didSet {
			if let height = statusBarHeight, height > 0 {
				_heightConstraint.constant = height
				_heightConstraint.isActive = true
			} else {
				_heightConstraint.isActive = false
			}
		}
	}
	
	fileprivate var _heightConstraint: NSLayoutConstraint!
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	fileprivate func commonInit() {
		setupViews()
		setupConstraints()
	}

	fileprivate func setupViews() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)
		
		titleLabel.textAlignment = .center
		titleLabel.textColor = UIColor.white
		titleLabel.font = UIFont.systemFont(ofSize: 24)
		
		backgroundColor = UIColor(red:79/255.0, green:30/255.0, blue:169/255.0, alpha:255/255.0)
	}

	fileprivate func setupConstraints() {
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

		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=top_min_spacing)-[titleLabel]-(>=bottom_min_spacing)-|", options: [], metrics: metrics, views: views)
		constraints += [NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)]
		
        _heightConstraint = self.constrainTo(height: 44)

		NSLayoutConstraint.activate(constraints)
	}
}
