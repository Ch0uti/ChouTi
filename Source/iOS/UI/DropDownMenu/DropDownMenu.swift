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
	
	private let animator = DropDownMenuAnimator()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		animator.dropDownMenu = self
		
		setupViews()
		setupConstraints()
		setupActions()
	}
	
	private func setupViews() {
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(textLabel)
		
		textLabel.text = "Menu Text"
	}

	private func setupConstraints() {
		preservesSuperviewLayoutMargins = false
		layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

		let views = [
			"textLabel" : textLabel
		]

		let metrics: [String : CGFloat] = [:]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textLabel]-|", options: [], metrics: metrics, views: views)
		
		constraints += [NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)]
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	private func setupActions() {
		self.addTarget(self, action: "tapped:forEvent:", forControlEvents: .TouchUpInside)
	}
	
	func tapped(sender: AnyObject, forEvent event: UIEvent) {
//		if !isExpandingOngoing {
//			expanded = !expanded
//		}
		
		let dummyViewController = UIViewController()
		dummyViewController.view.backgroundColor = UIColor(red:255/255.0, green:186/255.0, blue:1/255.0, alpha:255/255.0)
		dummyViewController.view.layer.cornerRadius = 4.0
		
		dummyViewController.view.userInteractionEnabled = true
		
		dummyViewController.modalPresentationStyle = .Custom
		dummyViewController.transitioningDelegate = animator
		
		presentingViewController?.presentViewController(dummyViewController, animated: true, completion: nil)
	}
}

extension DropDownMenu {
	func tapped(sender: AnyObject) {
		
//		presentingViewController.
	}
}
