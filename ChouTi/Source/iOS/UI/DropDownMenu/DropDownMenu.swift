//
//  DropDownMenu.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import UIKit

open class DropDownMenu: UIControl {

	// MARK: - Public

	/// The main text label showing current selected option
	public let textLabel = UILabel()

	/// Indicator view on right side, this usually an arrow, subclass should use this as a container view to add indicator view
    public let indicatorView = UIView()

	open var statusBarStyle: UIStatusBarStyle = .default {
		didSet {
			pickerViewController.statusBarStyle = statusBarStyle
		}
	}

	/// overlayViewStyle is for the blurred/dimmed view behind the menu picker view
	open var overlayViewStyle: OverlayViewStyle = .blurred(.dark, UIColor(white: 0.0, alpha: 0.4)) {
		didSet {
			menuAnimator.overlayViewStyle = overlayViewStyle
		}
	}

	/// Whether the menu is expanded
    @objc open internal(set) dynamic var expanded: Bool = false

	/// Drop down animation duration
	open var animationDuration: TimeInterval = 0.5 {
		didSet {
			menuAnimator.animationDuration = animationDuration
			pickerViewController.animationDuration = animationDuration
		}
	}

    /// placeholder text when no option is selected
	open var placeholder: String?

	/// Current selected index
	open var selectedIndex: Int? {
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
	open var optionTextColor: UIColor? {
		didSet {
			pickerViewController.optionTextColor = optionTextColor
		}
	}

	/// Menu options text font
	open var optionTextFont: UIFont? {
		didSet {
			pickerViewController.optionTextFont = optionTextFont
		}
	}

	/// Menu options text alignment
	open var optionTextAlignment: NSTextAlignment = .left {
		didSet {
			pickerViewController.optionTextAlignment = optionTextAlignment
		}
	}

	/// Menu options cell background color
	open var optionCellBackgroundColor: UIColor? {
		didSet {
			pickerViewController.optionCellBackgroundColor = optionCellBackgroundColor
		}
	}

	/// Color for separator between options
	open var optionSeparatorColor: UIColor? {
		didSet {
			pickerViewController.optionSeparatorColor = optionSeparatorColor
		}
	}

	/// DropDownMenuDataSource for drop down menu, must be set
	open weak var dataSource: DropDownMenuDataSource!

	/// DropDownMenuDelegate for drop down menu
	open weak var delegate: DropDownMenuDelegate?

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

	private var wrapperBaseWidthConstraint: NSLayoutConstraint!
	private var wrapperBaseHeightConstraint: NSLayoutConstraint!

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

		pickerViewController.modalPresentationStyle = .custom
		pickerViewController.transitioningDelegate = menuAnimator

		setupViews()
		setupConstraints()
		setupActions()
	}

	private func setupViews() {
		// Some default styles
		backgroundColor = UIColor(red: 255.0 / 255.0, green: 186.0 / 255.0, blue: 1.0 / 255.0, alpha: 255.0 / 255.0)
		textLabel.textColor = UIColor.white

		wrapperView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(wrapperView)

		wrapperView.isUserInteractionEnabled = false
		wrapperView.backgroundColor = UIColor.clear

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
			"wrapperView": wrapperView,
			"textLabel": textLabel,
			"indicatorView": indicatorView
		]

		let metrics: [String: CGFloat] = [:]

		var constraints = [NSLayoutConstraint]()

		wrapperTopConstraint = NSLayoutConstraint(item: wrapperView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
		wrapperLeadingConstraint = NSLayoutConstraint(item: wrapperView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
		wrapperBottomConstraint = NSLayoutConstraint(item: wrapperView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
		wrapperTrailingConstraint = NSLayoutConstraint(item: wrapperView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)

		// Setup base width/height constraint for wrapper, this is used for keeping wrapper size if menu (self) is get removed somehow
		wrapperBaseWidthConstraint = NSLayoutConstraint(item: wrapperView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0)
		wrapperBaseWidthConstraint.priority = UILayoutPriority(800) // 800 is greater 750, which is default content size constraint priority
		wrapperBaseHeightConstraint = NSLayoutConstraint(item: wrapperView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0)
		wrapperBaseHeightConstraint.priority = UILayoutPriority(800)

		constraints += [wrapperTopConstraint, wrapperLeadingConstraint, wrapperBottomConstraint, wrapperTrailingConstraint, wrapperBaseWidthConstraint, wrapperBaseHeightConstraint]

		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[textLabel]-[indicatorView]-|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[indicatorView]-|", options: [], metrics: metrics, views: views)
		constraints += [
			NSLayoutConstraint(item: indicatorView, attribute: .width, relatedBy: .equal, toItem: indicatorView, attribute: .height, multiplier: 1.0, constant: 0.0),
			NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .greaterThanOrEqual, toItem: wrapperView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
		]

		NSLayoutConstraint.activate(constraints)
	}

	private func setupActions() {
        self.addTarget(self, action: #selector(DropDownMenu.tapped(_:forEvent:)), for: .touchUpInside)
	}

	open override func layoutSubviews() {
		// Update base width/height constraint for wrapper view.
		wrapperBaseWidthConstraint.constant = bounds.width
		wrapperBaseHeightConstraint.constant = bounds.height

		super.layoutSubviews()
	}

	/**
	Add constrains for wrapper, this should be called once wrapper is moved in view hierarchy
	*/
	func setupWrapperViewConstraints() {
		// If self and wrapper view has no common ancestor, collapse and return
		if self.window != wrapperView.window {
			collapse(animated: false)
			return
		}

		var constraints = [NSLayoutConstraint]()
		constraints += [wrapperTopConstraint, wrapperLeadingConstraint, wrapperBottomConstraint, wrapperTrailingConstraint]
		NSLayoutConstraint.activate(constraints)
	}

    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

		if newWindow != nil {
			setupWrapperViewConstraints()
		}
    }
}

// MARK: - State Transition
extension DropDownMenu {

	public func set(toExpand: Bool, animated: Bool) {
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
    @objc
    func tapped(_ sender: AnyObject, forEvent event: UIEvent) {
		set(toExpand: !expanded, animated: true)
	}

	private func expand(animated: Bool) {
		// Access pickerViewController.view here instead of setupViews(), to avoid calling viewDidLoad in pickerViewController
		if pickerViewController.view.isUserInteractionEnabled == false {
			pickerViewController.view.isUserInteractionEnabled = true
		}

		willExpand()

		if animated {
			isAnimating = true
			presentingViewController?.present(pickerViewController, animated: true, completion: {
				self.isAnimating = false
			})
		} else {
			let originalAnimationDuration = animationDuration
			animationDuration = 0.0

			presentingViewController?.present(pickerViewController, animated: true, completion: { [unowned self] in
				self.animationDuration = originalAnimationDuration
			})
		}
	}

	private func collapse(animated: Bool) {
		if animated {
			isAnimating = true
			pickerViewController.dismiss(animated: true, completion: {
				self.isAnimating = false
			})
		} else {
			let originalAnimationDuration = animationDuration
			animationDuration = 0.0
			pickerViewController.dismiss(animated: true, completion: { [unowned self] in
				self.animationDuration = originalAnimationDuration
			})
		}
	}
}
