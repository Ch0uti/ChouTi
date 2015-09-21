//
//  SegmentedControl.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-06-16.
//

import UIKit

public class SegmentedControl: UISegmentedControl {
	
	// MARK: - Appearance
	
	/// Override tintColor, super.tintColor will be always clearColor
	/// When titleSelectedColor is nil, tintColor will be used
	private var _tintColor = UIColor.blueColor().colorWithAlphaComponent(0.5) {
		didSet {
			titleSelectedColor = _tintColor
			selectedUnderScoreView?.backgroundColor = _tintColor
		}
	}
	/// tintColor will be used for selected underscore bar color and it's a backup color for titleSelectedColor
	override public var tintColor: UIColor! {
		set {
			_tintColor = newValue
		}
		
		get {
			return _tintColor
		}
	}
	
	/// Selected color for item, if this color is nil, tintColor will be used
	public var titleSelectedColor: UIColor? {
		didSet {
			if selectedSegmentIndex >= 0, let color = titleSelectedColor {
				itemLabels[selectedSegmentIndex].textColor = color
			}
		}
	}
	/// Unselected color for item, if this color is nil, border color will be used
	public var titleUnSelectedColor: UIColor? {
		didSet {
			if let color = titleUnSelectedColor {
				for (index, label) in itemLabels.enumerate() {
					if index == selectedSegmentIndex {
						continue
					} else {
						label.textColor = color
					}
				}
			}
		}
	}
	
	public var titleFont: UIFont = UIFont.systemFontOfSize(13.0) {
		didSet {
			itemLabels.forEach { $0.font = self.titleFont }
		}
	}
	
	// Selected Under Score Indicator
	public var underScoreHeight: CGFloat = 4.0 {
		didSet {
			if let constraint = underScoreHeightConstraint {
				constraint.constant = underScoreHeight
			}
		}
	}
	
	
	
	// MARK: - Animations Related
	/// true for selection transition animation, false to turn off
	public var shouldBeAnimated: Bool = true
	/// transition animation duration
	public var animationDuration: NSTimeInterval = 0.2
	
	
	
	// MARK: - Layer Related
	/// Border color for border and separator, default color is light grey
	public var borderColor: UIColor = UIColor(white: 0.0, alpha: 0.10) {
		didSet {
			layer.borderColor = borderColor.CGColor
			itemSeparators.forEach { $0.backgroundColor = self.borderColor }
			if titleUnSelectedColor == nil { titleUnSelectedColor = borderColor }
		}
	}
	
	public var cornerRadius: CGFloat = 0.0 {
		didSet {
			layer.cornerRadius = cornerRadius
		}
	}
	
	private var borderWidth: CGFloat = 1.0 {
		didSet {
			layer.borderWidth = borderWidth
			layoutMargins = UIEdgeInsets(top: borderWidth, left: borderWidth, bottom: borderWidth, right: borderWidth)
		}
	}
	
	
	
	// MARK: - Privates
	/// titles on the segmented control
	public private(set) var itemTitles = [String]()
	private var itemLabels = [UILabel]()
	private var itemSeparators = [UIView]()
	
	private var selectedUnderScoreView: UIView!
	/// A flag marks whether the selection is the first time
	private var previousSelectedIndex: Int = -1
	
	// MARK: - Inner Constraints
	private var itemConstraints: [NSLayoutConstraint]?
	
	private var underScoreConstraints: [NSLayoutConstraint]?
	private var underScoreHeightConstraint: NSLayoutConstraint?
	private var underScoreLeadingConstraint: NSLayoutConstraint?
	private var underScoreTrailingConstraint: NSLayoutConstraint?
	
	// MARK: - Init
	/**
	Init with items. Note here, items must be an array of title strings, images segments are not supported yet.
	
	:param: items An array of title strings
	
	:returns: An initalized segmented control
	*/
	public override init(items: [AnyObject]?) {
		super.init(items: items)
		if let titles = items as? [String] {
			setupWithTitles(titles)
		} else {
			fatalError("init with images is not implemented")
		}
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		// Clear default border color and title color
		super.tintColor = UIColor.clearColor()
		
		self.layer.borderColor = borderColor.CGColor
		self.layer.borderWidth = borderWidth
		self.layer.cornerRadius = cornerRadius
		
		clipsToBounds = true
		
		self.addTarget(self, action: "zh_selectedIndexChanged:", forControlEvents: .ValueChanged)
	}
	
	// MARK: - Setup with Titles
	/**
	Setup segmented control with a list of titles, this will removed all previous titles.
	
	:param: titles an array of titles
	*/
	public func setupWithTitles(titles: [String]) {
		super.removeAllSegments()
		for (index, title) in titles.enumerate() {
			super.insertSegmentWithTitle(title, atIndex: index, animated: false)
		}
		
		setupItemsWithTitles(titles)
		setupUnderScoreView()
		
		setupItemConstraints()
		setupUnderScoreViewConstraints()
	}
	
	// MARK: - Setup Views
	/**
	Setup title labels and separators. This will clear all previous title labels and separators and setup new ones.
	
	:param: titles title strings
	*/
	private func setupItemsWithTitles(titles: [String]) {
		itemLabels.forEach { $0.removeFromSuperview() }
		itemSeparators.forEach { $0.removeFromSuperview() }
		
		itemTitles = titles
		itemLabels = []
		itemSeparators = []

		let titlesCount = titles.count
		for (index, title) in titles.enumerate() {
			let label = itemLabelWithTitle(title)
			self.addSubview(label)
			itemLabels.append(label)
			
			if titlesCount > 1 && index < titlesCount {
				let separator = itemSeparatorView()
				self.addSubview(separator)
				itemSeparators.append(separator)
			}
		}
	}
	
	/**
	Setup under score bar view, which is a hightlight bottom bar for selected title
	*/
	private func setupUnderScoreView() {
		if selectedUnderScoreView == nil {
			selectedUnderScoreView = UIView()
			selectedUnderScoreView.translatesAutoresizingMaskIntoConstraints = false
			selectedUnderScoreView.backgroundColor = titleSelectedColor ?? tintColor
			self.addSubview(selectedUnderScoreView)
		}
	}
	
	// MARK: - Setup Layout
	/**
	Setup constraints for title labels and separators. It chains labels and separators from leading to trailing
	*/
	private func setupItemConstraints() {
		// Consider borderWidth in layout margins, this will let under score bar align to border correctly
		layoutMargins = UIEdgeInsets(top: borderWidth, left: borderWidth, bottom: borderWidth, right: borderWidth)
		
		if itemConstraints != nil {
			NSLayoutConstraint.deactivateConstraints(itemConstraints!)
		}
		
		itemConstraints = [NSLayoutConstraint]()
		
		// Check titles count after cleaning itemConstraints
		let titlesCount = itemLabels.count
		if titlesCount == 0 {
			return
		}
		
		if titlesCount == 1 {
			let views = ["label": itemLabels[0]]
			itemConstraints! += NSLayoutConstraint.constraintsWithVisualFormat("|[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
			itemConstraints! += NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
		} else {
			for (index, label) in itemLabels.enumerate() {
				if index == 0 {
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0))
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
				} else {
					let lastIndex = index - 1
					let previousLabel = itemLabels[lastIndex]
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: previousLabel, attribute: .Trailing, multiplier: 1.0, constant: borderWidth))
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: previousLabel, attribute: .Width, multiplier: 1.0, constant: 0.0))
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: previousLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
					
					// Separator
					let separator = itemSeparators[lastIndex]
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Leading, relatedBy: .Equal, toItem: separator, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
					itemConstraints!.append(NSLayoutConstraint(item: separator, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: borderWidth))
					itemConstraints!.append(NSLayoutConstraint(item: separator, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
					itemConstraints!.append(NSLayoutConstraint(item: separator, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
				}
				
				if index == titlesCount - 1 {
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0))
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
					itemConstraints!.append(NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
				}
			}
		}
		
		NSLayoutConstraint.activateConstraints(itemConstraints!)
	}
	
	/**
	Setup constraints for under score bar view. By default, it's height is zero.
	*/
	private func setupUnderScoreViewConstraints() {
		if underScoreConstraints != nil {
			NSLayoutConstraint.deactivateConstraints(underScoreConstraints!)
		}
		
		underScoreConstraints = [NSLayoutConstraint]()
		
		// If there's no items, don't setup constraints
		if itemLabels.count == 0 {
			return
		}
		
		underScoreHeightConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 0.0)
		underScoreConstraints!.append(underScoreHeightConstraint!)
		
		underScoreLeadingConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
		underScoreConstraints!.append(underScoreLeadingConstraint!)
		
		underScoreTrailingConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
		underScoreConstraints!.append(underScoreTrailingConstraint!)
		
		underScoreConstraints!.append(NSLayoutConstraint(item: selectedUnderScoreView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
		
		NSLayoutConstraint.activateConstraints(underScoreConstraints!)
	}
	
	
	
	// MARK: - Overridden
	public override func removeTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
		super.removeTarget(target, action: action, forControlEvents: controlEvents)
		
		// If trying to remove all targets, add self as target back again
		if target == nil {
			self.addTarget(self, action: "zh_selectedIndexChanged:", forControlEvents: .ValueChanged)
		}
	}
	
	// MARK: - Managing Segment Control
	public override func setImage(image: UIImage?, forSegmentAtIndex segment: Int) {
		fatalError("Image segment control is not supported yet")
	}
	
	public override func imageForSegmentAtIndex(segment: Int) -> UIImage? {
		fatalError("Image segment control is not supported yet")
	}
	
	public override func setTitle(title: String?, forSegmentAtIndex segment: Int) {
		precondition(segment < itemTitles.count, "segment index out of range")
		if let titleText = title {
			super.setTitle(titleText, forSegmentAtIndex: segment)
			itemTitles[segment] = titleText
			itemLabels[segment].text = titleText
		}
	}
	
	public override func titleForSegmentAtIndex(segment: Int) -> String? {
		precondition(segment < itemTitles.count, "segment index out of range")
		return itemTitles[segment]
	}
	
	// MARK: - Managing Segments
	public override func insertSegmentWithImage(image: UIImage?, atIndex segment: Int, animated: Bool) {
		fatalError("Image segment control is not supported yet")
	}
	
	public override func insertSegmentWithTitle(title: String!, atIndex segment: Int, animated: Bool) {
		fatalError("Not implemented")
	}
	
	public override var numberOfSegments: Int {
		return itemTitles.count
	}
	
	public override func removeAllSegments() {
		setupWithTitles([])
	}
	
	public override func removeSegmentAtIndex(segment: Int, animated: Bool) {
		fatalError("Not implemented")
	}
	
	public override var selectedSegmentIndex: Int {
		didSet {
			updateSelectedIndex(selectedSegmentIndex)
			previousSelectedIndex = selectedSegmentIndex
		}
	}
	
	// MARK: - Managing Segment Behavior and Appearance
	public override var momentary: Bool {
		didSet {
			fatalError("Not implemented")
		}
	}
	
	public override func setEnabled(enabled: Bool, forSegmentAtIndex segment: Int) {
		super.setEnabled(enabled, forSegmentAtIndex: segment)
		precondition(segment < itemTitles.count, "segment is out of range")
		itemLabels[segment].enabled = false
	}
	
	public override func isEnabledForSegmentAtIndex(segment: Int) -> Bool {
		return super.isEnabledForSegmentAtIndex(segment)
	}
	
	public override func setContentOffset(offset: CGSize, forSegmentAtIndex segment: Int) {
		fatalError("Not implemented")
	}
	
	public override func contentOffsetForSegmentAtIndex(segment: Int) -> CGSize {
		fatalError("Not implemented")
	}
	
	public override func setWidth(width: CGFloat, forSegmentAtIndex segment: Int) {
		fatalError("Not implemented")
	}
	
	public override func widthForSegmentAtIndex(segment: Int) -> CGFloat {
		fatalError("Not implemented")
	}
	
	public override var apportionsSegmentWidthsByContent: Bool {
		didSet {
			fatalError("Not implemented")
		}
	}
}

// MARK: - Helper
extension SegmentedControl {
	// Creators
	/**
	Create a title label, common setups.
	
	:param: title title string
	
	:returns: a new UILabel instance
	*/
	private func itemLabelWithTitle(title: String) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		
		label.text = title
		label.textAlignment = .Center
		label.font = titleFont
		label.textColor = titleUnSelectedColor ?? borderColor
		
		return label
	}
	
	/**
	Create a separator line view
	
	:returns: a new UIView instance
	*/
	private func itemSeparatorView() -> UIView {
		let separator = UIView()
		separator.translatesAutoresizingMaskIntoConstraints = false
		
		separator.backgroundColor = borderColor
		
		return separator
	}
	
	/**
	Add a fade in/out transition animation for UILabel
	
	:param: label label that needs a fade in/out animation
	*/
	private func addFadeTransitionAnimationForLabel(label: UILabel?) {
		let textAnimation = CATransition()
		textAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		textAnimation.type = kCATransitionFade
		textAnimation.duration = shouldBeAnimated ? animationDuration : 0.0
		
		label?.layer.addAnimation(textAnimation, forKey: "TextFadeAnimation")
	}
	
	// Others
	/**
	Perform animation for updating selected index
	
	:param: index new selected index
	*/
	private func updateSelectedIndex(index: Int) {
		var previousLabel: UILabel? = nil
		if previousSelectedIndex >= 0 {
			previousLabel = itemLabels[previousSelectedIndex]
		}
		let currentLabel = itemLabels[index]
		
		NSLayoutConstraint.deactivateConstraints([underScoreLeadingConstraint!, underScoreTrailingConstraint!])
		
		underScoreLeadingConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .Leading, relatedBy: .Equal, toItem: currentLabel, attribute: .Leading, multiplier: 1.0, constant: 0.0)
		underScoreTrailingConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .Trailing, relatedBy: .Equal, toItem: currentLabel, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
		
		NSLayoutConstraint.activateConstraints([underScoreLeadingConstraint!, underScoreTrailingConstraint!])
		
		// If there's no selected index, means it's the first time selection, update width and centerX without animation
		if previousSelectedIndex == -1 {
			self.layoutIfNeeded()
		}
		
		underScoreHeightConstraint?.constant = underScoreHeight
		
		addFadeTransitionAnimationForLabel(previousLabel)
		addFadeTransitionAnimationForLabel(currentLabel)
		
		UIView.animateWithDuration(shouldBeAnimated ? animationDuration : 0.0, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: { () -> Void in
			previousLabel?.textColor = self.titleUnSelectedColor ?? self.borderColor
			currentLabel.textColor = self.titleSelectedColor ?? self.tintColor
			
			self.layoutIfNeeded()
		}, completion: nil)
	}
}

extension SegmentedControl {
	@objc private func zh_selectedIndexChanged(sender: AnyObject) {
		if let segmentedControl = sender as? UISegmentedControl {
			updateSelectedIndex(segmentedControl.selectedSegmentIndex)
			previousSelectedIndex = segmentedControl.selectedSegmentIndex
		}
	}
}
