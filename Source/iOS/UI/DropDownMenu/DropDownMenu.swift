//
//  DropDownMenu.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import UIKit

public class DropDownMenu: UIControl {
	public let textLabel = UILabel()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(textLabel)

		textLabel.text = "Menu Text"
		
		let tapGesture = UITapGestureRecognizer(target: self, action: "tapped:")
		self.addGestureRecognizer(tapGesture)
		
		setupConstraints()
	}

	private func setupConstraints() {
		preservesSuperviewLayoutMargins = false
		layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

		let views = [
			"textLabel" : textLabel
		]

		let metrics: [String : CGFloat] = [
			"vertical_spacing" : 4.0
		]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textLabel]-|", options: [], metrics: metrics, views: views)
		
		let topConstraint = NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .TopMargin, multiplier: 1.0, constant: 0.0)
		topConstraint.priority = 500
		let bottomConstraint = NSLayoutConstraint(item: textLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0)
		bottomConstraint.priority = 500
		
		constraints += [topConstraint, bottomConstraint]
		
		constraints += [NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)]
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
}

extension DropDownMenu {
	func tapped(sender: AnyObject) {
//		let 
//		presentingViewController.
	}
}
