//
//  DropDownMenu.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import UIKit

public class DropDownMenu: UIControl {
	
	// MARK: - Public
	public let textLabel = UILabel()
	// TODO: Include arrow image asset
//	public let indicatorView: UIView?
	
	/// overlayViewStyle is the blurred/dimmed view behind the menu picker view
	public var overlayViewStyle: OverlayViewStyle = .Blurred(.Dark, UIColor(white: 0.0, alpha: 0.4)) {
		didSet {
			menuAnimator.overlayViewStyle = overlayViewStyle
		}
	}
	
	/// whether the menu is expanded
	public private(set) var expanded: Bool = false
	
	public var animationDuration: NSTimeInterval = 0.5
	
	public var selectedIndex: Int = 0 {
		didSet {
			// TODO: Wrap this into extension
			if textLabel.layer.animationForKey("TextTransition") == nil {
				// Add transition (must be called after myLabel has been displayed)
				let animation = CATransition()
				animation.duration = animationDuration / 2.0
				animation.type = kCATransitionFade
				animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
				textLabel.layer.addAnimation(animation, forKey: "TextTransition")
			}
			
			textLabel.text = dataSource.dropDownMenu(self, optionTitleForIndex: selectedIndex)
		}
	}
	
	public var optionTextColor: UIColor? {
		didSet {
			pickerViewController.optionTextColor = optionTextColor
		}
	}
	
	public var optionTextFont: UIFont? {
		didSet {
			pickerViewController.optionTextFont = optionTextFont
		}
	}
	
	public var optionTextAlignment: NSTextAlignment = .Left {
		didSet {
			pickerViewController.optionTextAlignment = optionTextAlignment
		}
	}
	
	public var optionCellBackgroundColor: UIColor? {
		didSet {
			pickerViewController.optionCellBackgroundColor = optionCellBackgroundColor
		}
	}
	
	public var optionSeparatorColor: UIColor? {
		didSet {
			pickerViewController.optionSeparatorColor = optionSeparatorColor
		}
	}
	
	public weak var dataSource: DropDownMenuDataSource!
	public weak var delegate: DropDownMenuDelegate?
	
	
	
	// MARK: - Internal
	/// wrapperView is the common super view for all subviews like label and indicator
	let wrapperView = UIView()
	
	let pickerViewController = DropDownMenuPickerViewController()
	
	
	
	// MARK: - Private
	/// the animator operates the presenting of menu picker view
	let menuAnimator = DropDownMenuAnimator()
	
	/// whether is expading or collapsing
	private var isAnimating: Bool = false
	
	// Constraints
	private var wrapperTopConstraint: NSLayoutConstraint!
	private var wrapperLeadingConstraint: NSLayoutConstraint!
	private var wrapperBottomConstraint: NSLayoutConstraint!
	private var wrapperTrailingConstraint: NSLayoutConstraint!
	
	
	
	// MARK: - Setups
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		menuAnimator.dropDownMenu = self
		menuAnimator.overlayViewStyle = overlayViewStyle
		menuAnimator.animationDuration = animationDuration
		
		pickerViewController.dropDownMenu = self
		pickerViewController.animationDuration = animationDuration
		
		pickerViewController.modalPresentationStyle = .Custom
		pickerViewController.transitioningDelegate = menuAnimator
		
		setupViews()
		setupConstraints()
		setupActions()
	}
	
	private func setupViews() {
		backgroundColor = UIColor(red: 255.0 / 255.0, green: 186.0 / 255.0, blue: 1.0 / 255.0, alpha: 255.0 / 255.0)
		textLabel.textColor = UIColor.whiteColor()
		
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
	
	private func setupActions() {
		self.addTarget(self, action: "tapped:forEvent:", forControlEvents: .TouchUpInside)
	}
	
	func setupWrapperViewConstraints() {
		var constraints = [NSLayoutConstraint]()
		constraints += [wrapperTopConstraint, wrapperLeadingConstraint, wrapperBottomConstraint, wrapperTrailingConstraint]
		NSLayoutConstraint.activateConstraints(constraints)
	}
}



// MARK: - Actions
extension DropDownMenu {
	func tapped(sender: AnyObject, forEvent event: UIEvent) {
		if isAnimating { return }
		
		if expanded {
			// Collapse
			// This is already handled by animator tap gesture, nothing to do here
		} else {
			// Expand
			pickerViewController.view.userInteractionEnabled = true
			
			isAnimating = true
			presentingViewController?.presentViewController(pickerViewController, animated: true, completion: { finished in
				self.isAnimating = false
			})
		}
	}
}
