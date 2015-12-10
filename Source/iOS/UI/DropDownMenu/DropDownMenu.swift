//
//  DropDownMenu.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import UIKit

public class DropDownMenu: UIControl {
	/// wrapperView is the common super view for all subviews like label and indicator
	let wrapperView = UIView()
	
	public let textLabel = UILabel()
//	public let indicatorView: UIView?
	
	private let animator = DropDownMenuAnimator()
	
	private var isExpanding: Bool = false
	
	public private(set) var expanded: Bool = false
	
	// Constraints
	var wrapperTopConstraint: NSLayoutConstraint!
	var wrapperLeadingConstraint: NSLayoutConstraint!
	var wrapperBottomConstraint: NSLayoutConstraint!
	var wrapperTrailingConstraint: NSLayoutConstraint!
	
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
		wrapperView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(wrapperView)
		
		wrapperView.userInteractionEnabled = false
		wrapperView.backgroundColor = UIColor.clearColor()
		
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		wrapperView.addSubview(textLabel)
		
		textLabel.text = "Menu Text"
	}

	private func setupConstraints() {
		preservesSuperviewLayoutMargins = false
		layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

		let views = [
			"wrapperView" : wrapperView,
			"textLabel" : textLabel
		]

		let metrics: [String : CGFloat] = [:]

		var constraints = [NSLayoutConstraint]()

		wrapperTopConstraint = NSLayoutConstraint(item: wrapperView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
		wrapperLeadingConstraint = NSLayoutConstraint(item: wrapperView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
		wrapperBottomConstraint = NSLayoutConstraint(item: wrapperView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		wrapperTrailingConstraint = NSLayoutConstraint(item: wrapperView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
		
		constraints += [wrapperTopConstraint, wrapperLeadingConstraint, wrapperBottomConstraint, wrapperTrailingConstraint]
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textLabel]-|", options: [], metrics: metrics, views: views)
		constraints += [NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .GreaterThanOrEqual, toItem: wrapperView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)]
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	func setupWrapperViewConstraints() {
		var constraints = [NSLayoutConstraint]()
		constraints += [wrapperTopConstraint, wrapperLeadingConstraint, wrapperBottomConstraint, wrapperTrailingConstraint]
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	private func setupActions() {
		self.addTarget(self, action: "tapped:forEvent:", forControlEvents: .TouchUpInside)
	}
	
	func tapped(sender: AnyObject, forEvent event: UIEvent) {
//		if isExpanding { return }
//		
//		if expanded {
//			// Collapse
//		} else {
//			// Expand
//		}
//		
//		let overlayView = self.window?.insertOverlayViewBelowSubview(wrapperView, animated: true, overlayViewBackgroundColor: UIColor(white: 0.0, alpha: 0.6))
//		setupWrapperViewConstraints()
		
//			addOverlayView(animated: true, overlayViewBackgroundColor: UIColor(white: 0.0, alpha: 0.6), completion: nil)
		
//		overlayView!.addSubview(self.wrapperView)
//		var constraints = [NSLayoutConstraint]()
//		constraints += [self.wrapperTopConstraint, self.wrapperLeadingConstraint, self.wrapperBottomConstraint, self.wrapperTrailingConstraint]
//		NSLayoutConstraint.activateConstraints(constraints)
		
		
		
		
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
