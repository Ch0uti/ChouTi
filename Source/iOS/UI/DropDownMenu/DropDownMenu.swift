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
	
	/// The main text label showing current selected option
	public let textLabel = UILabel()
	
	/// Indicator view on right side, this usually an arrow, subclass should use this as a container view to add indicator view
	public let indicatorView = UIView()
	
	public var statusBarStyle: UIStatusBarStyle = .Default {
		didSet {
			pickerViewController.statusBarStyle = statusBarStyle
		}
	}
	
	/// overlayViewStyle is for the blurred/dimmed view behind the menu picker view
	public var overlayViewStyle: OverlayViewStyle = .Blurred(.Dark, UIColor(white: 0.0, alpha: 0.4)) {
		didSet {
			menuAnimator.overlayViewStyle = overlayViewStyle
		}
	}
	
	/// Whether the menu is expanded
	public internal(set) dynamic var expanded: Bool = false
	
	/// Drop down animation duration
	public var animationDuration: NSTimeInterval = 0.5 {
		didSet {
			menuAnimator.animationDuration = animationDuration
			pickerViewController.animationDuration = animationDuration
		}
	}
    
    /// placeholder text when no option is selected
	public var placeholder: String?
    
	/// Current selected index
	public var selectedIndex: Int? {
		didSet {
            guard let selectedIndex = selectedIndex else {
                textLabel.addFadeTransitionAnimation(animationDuration / 2.0)
                textLabel.text = placeholder
                return
            }
            
            guard selectedIndex >= 0 else {
                assertionFailure("Warning: You shouldn't set selectedIndex to negative value")
                return
            }
            
            textLabel.addFadeTransitionAnimation(animationDuration / 2.0)
			textLabel.text = dataSource.dropDownMenu(self, optionTitleForIndex: selectedIndex)
		}
	}
	
	/// Menu options text color
	public var optionTextColor: UIColor? {
		didSet {
			pickerViewController.optionTextColor = optionTextColor
		}
	}
	
	/// Menu options text font
	public var optionTextFont: UIFont? {
		didSet {
			pickerViewController.optionTextFont = optionTextFont
		}
	}
	
	/// Menu options text alignment
	public var optionTextAlignment: NSTextAlignment = .Left {
		didSet {
			pickerViewController.optionTextAlignment = optionTextAlignment
		}
	}
	
	/// Menu options cell background color
	public var optionCellBackgroundColor: UIColor? {
		didSet {
			pickerViewController.optionCellBackgroundColor = optionCellBackgroundColor
		}
	}
	
	/// Color for separator between options
	public var optionSeparatorColor: UIColor? {
		didSet {
			pickerViewController.optionSeparatorColor = optionSeparatorColor
		}
	}
	
	/// DropDownMenuDataSource for drop down menu, must be set
	public weak var dataSource: DropDownMenuDataSource!
	
	/// DropDownMenuDelegate for drop down menu
	public weak var delegate: DropDownMenuDelegate?
	
	
	
	// MARK: - Internal
	
	/// wrapperView is the common super view for all subviews like label and indicator
	//	Discussion:
	//		When menu is expanded, this wrapper view will be added on this overlay view with same position
	//		This will make the user feels the menu is not moved and options are sliding behind the menu
	let wrapperView = UIView()
	
	/// Options picker view controller, this is essentially a table view controller
	let pickerViewController = DropDownMenuPickerViewController()
	
	
	
	// MARK: - Private
	
	/// The animator operates the presenting of menu options picker view controller
	let menuAnimator = DropDownMenuAnimator()
	
	/// Whether is expading or collapsing
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
		pickerViewController.statusBarStyle = statusBarStyle
		pickerViewController.animationDuration = animationDuration
		
		pickerViewController.modalPresentationStyle = .Custom
		pickerViewController.transitioningDelegate = menuAnimator
		
		setupViews()
		setupConstraints()
		setupActions()
	}
	
	private func setupViews() {
		// Some default styles
		backgroundColor = UIColor(red: 255.0 / 255.0, green: 186.0 / 255.0, blue: 1.0 / 255.0, alpha: 255.0 / 255.0)
		textLabel.textColor = UIColor.whiteColor()
		
		wrapperView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(wrapperView)
		
		wrapperView.userInteractionEnabled = false
		wrapperView.backgroundColor = UIColor.clearColor()
		
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		wrapperView.addSubview(textLabel)
		
		textLabel.text = "Menu Text"
		
		indicatorView.translatesAutoresizingMaskIntoConstraints = false
		wrapperView.addSubview(indicatorView)
	}

	private func setupConstraints() {
		preservesSuperviewLayoutMargins = false
		layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

		let views = [
			"wrapperView" : wrapperView,
			"textLabel" : textLabel,
			"indicatorView" : indicatorView
		]

		let metrics: [String : CGFloat] = [:]

		var constraints = [NSLayoutConstraint]()

		wrapperTopConstraint = NSLayoutConstraint(item: wrapperView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
		wrapperLeadingConstraint = NSLayoutConstraint(item: wrapperView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
		wrapperBottomConstraint = NSLayoutConstraint(item: wrapperView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
		wrapperTrailingConstraint = NSLayoutConstraint(item: wrapperView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
		
		constraints += [wrapperTopConstraint, wrapperLeadingConstraint, wrapperBottomConstraint, wrapperTrailingConstraint]
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textLabel]-[indicatorView]-|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[indicatorView]-|", options: [], metrics: metrics, views: views)
		constraints += [
			NSLayoutConstraint(item: indicatorView, attribute: .Width, relatedBy: .Equal, toItem: indicatorView, attribute: .Height, multiplier: 1.0, constant: 0.0),
			NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .GreaterThanOrEqual, toItem: wrapperView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
			]
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	private func setupActions() {
		self.addTarget(self, action: "tapped:forEvent:", forControlEvents: .TouchUpInside)
	}
	
	/**
	Add constrains for wrapper, this should be called once wrapper is moved in view hierarchy
	*/
	func setupWrapperViewConstraints() {
		var constraints = [NSLayoutConstraint]()
		constraints += [wrapperTopConstraint, wrapperLeadingConstraint, wrapperBottomConstraint, wrapperTrailingConstraint]
		NSLayoutConstraint.activateConstraints(constraints)
	}
    
    public override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        setupWrapperViewConstraints()
    }
}


// MARK: - State Transition
extension DropDownMenu {
	
	public func set(toExpand toExpand: Bool, animated: Bool) {
		if isAnimating { return }
		if expanded == toExpand { return }
		if toExpand {
			expand(animated: animated)
		} else {
			collapse(animated: animated)
		}
	}
	
	func willExpand() {
		delegate?.dropDownMenuWillExpand?(self)
	}
	
	func didExpand() {
		delegate?.dropDownMenuDidExpand?(self)
	}

	func willCollapse() {
		delegate?.dropDownMenuWillCollapse?(self)
	}

	func didCollapse() {
		delegate?.dropDownMenuDidCollapse?(self)
	}
}



// MARK: - Actions
extension DropDownMenu {
	func tapped(sender: AnyObject, forEvent event: UIEvent) {
		set(toExpand: !expanded, animated: true)
	}
	
	private func expand(animated animated: Bool) {
		// Access pickerViewController.view here instead of setupViews(), to avoid calling viewDidLoad in pickerViewController
		if pickerViewController.view.userInteractionEnabled == false {
			pickerViewController.view.userInteractionEnabled = true
		}
		
		willExpand()
		
		if animated {
			isAnimating = true
			presentingViewController?.presentViewController(pickerViewController, animated: true, completion: { finished in
				self.isAnimating = false
			})
		} else {
			let originalAnimationDuration = animationDuration
			animationDuration = 0.0
			
			presentingViewController?.presentViewController(pickerViewController, animated: true, completion: { [unowned self] finished in
				self.animationDuration = originalAnimationDuration
			})
		}
	}

	private func collapse(animated animated: Bool) {
		if animated {
			pickerViewController.dismissViewControllerAnimated(true, completion: nil)
		} else {
			let originalAnimationDuration = animationDuration
			animationDuration = 0.0
			pickerViewController.dismissViewControllerAnimated(true, completion: { [unowned self] finished in
				self.animationDuration = originalAnimationDuration
			})
		}
	}
}
