//
//  Created by Honghao Zhang on 06/16/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

open class SegmentedControl: UISegmentedControl {

	// MARK: - Appearance

	/// Override tintColor, super.tintColor will be always clearColor
	/// When titleSelectedColor is nil, tintColor will be used
	private var _tintColor = UIColor.blue.withAlphaComponent(0.5) {
		didSet {
			titleSelectedColor = _tintColor
			selectedUnderScoreView?.backgroundColor = _tintColor
		}
	}
	/// tintColor will be used for selected underscore bar color and it's a backup color for titleSelectedColor
	override open var tintColor: UIColor! {
		set {
			_tintColor = newValue
		}

		get {
			return _tintColor
		}
	}

	/// Selected color for item, if this color is nil, tintColor will be used
	open var titleSelectedColor: UIColor? {
		didSet {
			if selectedSegmentIndex >= 0, let color = titleSelectedColor {
				itemLabels[selectedSegmentIndex].textColor = color
			}
		}
	}
	/// Unselected color for item, if this color is nil, border color will be used
	open var titleUnSelectedColor: UIColor? {
		didSet {
			if let color = titleUnSelectedColor {
				for (index, label) in itemLabels.enumerated() {
					if index == selectedSegmentIndex {
						continue
					} else {
						label.textColor = color
					}
				}
			}
		}
	}

	open var titleFont = UIFont.systemFont(ofSize: 13.0) {
		didSet {
			itemLabels.forEach { $0.font = self.titleFont }
		}
	}

	// Selected Under Score Indicator
	open var underScoreHeight: CGFloat = 4.0 {
		didSet {
			if let constraint = underScoreHeightConstraint {
				constraint.constant = underScoreHeight
			}
		}
	}

	// MARK: - Animations Related
	/// true for selection transition animation, false to turn off
	open var shouldBeAnimated: Bool = true
	/// transition animation duration
	open var animationDuration: TimeInterval = 0.2

	// MARK: - Layer Related
	/// Border color for border and separator, default color is light grey
	open var borderColor = UIColor(white: 0.0, alpha: 0.10) {
		didSet {
			layer.borderColor = borderColor.cgColor
			itemSeparators.forEach { $0.backgroundColor = self.borderColor }
			if titleUnSelectedColor == nil { titleUnSelectedColor = borderColor }
		}
	}

	open var cornerRadius: CGFloat = 0.0 {
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
	open private(set) var itemTitles = [String]()
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
    /// Init with items. Note here, items must be an array of title strings, images segments are not supported yet.
    ///
    /// - Parameter items: An array of title strings
	override public init(items: [Any]?) {
		super.init(items: items)
		if let titles = items as? [String] {
			setupWithTitles(titles)
		} else {
			fatalError("init with images is not implemented")
		}
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		// Clear default border color and title color
		super.tintColor = UIColor.clear

		self.layer.borderColor = borderColor.cgColor
		self.layer.borderWidth = borderWidth
		self.layer.cornerRadius = cornerRadius

		clipsToBounds = true

        self.addTarget(self, action: #selector(SegmentedControl.zh_selectedIndexChanged(_:)), for: .valueChanged)
	}

	// MARK: - Setup with Titles
    /// Setup segmented control with a list of titles, this will removed all previous titles.
    ///
    /// - Parameter titles: an array of titles
	open func setupWithTitles(_ titles: [String]) {
		// If existed titles are same with new titles, return
		if itemTitles == titles {
			return
		}

		// new titles are different, reset
		super.removeAllSegments()
		for (index, title) in titles.enumerated() {
			super.insertSegment(withTitle: title, at: index, animated: false)
		}

		setupItemsWithTitles(titles)
		setupUnderScoreView()

		setupItemConstraints()
		setupUnderScoreViewConstraints()
	}

	// MARK: - Setup Views
    /// Setup title labels and separators. This will clear all previous title labels and separators and setup new ones.
    ///
    /// - Parameter titles: titles title strings
	private func setupItemsWithTitles(_ titles: [String]) {
		itemLabels.forEach { $0.removeFromSuperview() }
		itemSeparators.forEach { $0.removeFromSuperview() }

		itemTitles = titles
		itemLabels = []
		itemSeparators = []

		let titlesCount = titles.count
		for (index, title) in titles.enumerated() {
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

	/// Setup under score bar view, which is a hightlight bottom bar for selected title
	private func setupUnderScoreView() {
		if selectedUnderScoreView == nil {
			selectedUnderScoreView = UIView()
			selectedUnderScoreView.translatesAutoresizingMaskIntoConstraints = false
			selectedUnderScoreView.backgroundColor = titleSelectedColor ?? tintColor
			self.addSubview(selectedUnderScoreView)
		}
	}

	// MARK: - Setup Layout
    /// Setup constraints for title labels and separators. It chains labels and separators from leading to trailing
	private func setupItemConstraints() {
		// Consider borderWidth in layout margins, this will let under score bar align to border correctly
		layoutMargins = UIEdgeInsets(top: borderWidth, left: borderWidth, bottom: borderWidth, right: borderWidth)

		if let itemConstraints = self.itemConstraints {
			NSLayoutConstraint.deactivate(itemConstraints)
		}

        var itemConstraints: [NSLayoutConstraint] = []

		// Check titles count after cleaning itemConstraints
		let titlesCount = itemLabels.count
		if titlesCount == 0 {
			return
		}

		if titlesCount == 1 {
			let views = ["label": itemLabels[0]]
			itemConstraints += NSLayoutConstraint.constraints(withVisualFormat: "|[label]|", options: [], metrics: nil, views: views)
			itemConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: views)
		} else {
			for (index, label) in itemLabels.enumerated() {
				if index == 0 {
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0))
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
				} else {
					let lastIndex = index - 1
					let previousLabel = itemLabels[lastIndex]
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: previousLabel, attribute: .trailing, multiplier: 1.0, constant: borderWidth))
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: previousLabel, attribute: .width, multiplier: 1.0, constant: 0.0))
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: previousLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))

					// Separator
					let separator = itemSeparators[lastIndex]
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: .equal, toItem: separator, attribute: .trailing, multiplier: 1.0, constant: 0.0))
					itemConstraints.append(NSLayoutConstraint(item: separator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: borderWidth))
					itemConstraints.append(NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
					itemConstraints.append(NSLayoutConstraint(item: separator, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
				}

				if index == titlesCount - 1 {
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0))
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
					itemConstraints.append(NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
				}
			}
		}

        self.itemConstraints = itemConstraints

		NSLayoutConstraint.activate(itemConstraints)
	}

    /// Setup constraints for under score bar view. By default, it's height is zero.
	private func setupUnderScoreViewConstraints() {
		if let underScoreConstraints = self.underScoreConstraints {
			NSLayoutConstraint.deactivate(underScoreConstraints)
		}

        var underScoreConstraints: [NSLayoutConstraint] = []

		// If there's no items, don't setup constraints
		if itemLabels.isEmpty {
			return
		}

		let underScoreHeightConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0.0)
        self.underScoreHeightConstraint = underScoreHeightConstraint
		underScoreConstraints.append(underScoreHeightConstraint)

		let underScoreLeadingConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        self.underScoreLeadingConstraint = underScoreLeadingConstraint
		underScoreConstraints.append(underScoreLeadingConstraint)

		let underScoreTrailingConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        self.underScoreTrailingConstraint = underScoreTrailingConstraint
		underScoreConstraints.append(underScoreTrailingConstraint)

		underScoreConstraints.append(NSLayoutConstraint(item: selectedUnderScoreView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))

        self.underScoreConstraints = underScoreConstraints
		NSLayoutConstraint.activate(underScoreConstraints)
	}

	// MARK: - Overridden
	override open func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
		super.removeTarget(target, action: action, for: controlEvents)

		// If trying to remove all targets, add self as target back again
		if target == nil {
            self.addTarget(self, action: #selector(SegmentedControl.zh_selectedIndexChanged(_:)), for: .valueChanged)
		}
	}
}

// MARK: - Managing Segment Control
extension SegmentedControl {
    @available(*, unavailable)
    override open func setImage(_ image: UIImage?, forSegmentAt segment: Int) {
        fatalError("Image segment control is not supported yet")
    }

    @available(*, unavailable)
    override open func imageForSegment(at segment: Int) -> UIImage? {
        fatalError("Image segment control is not supported yet")
    }

    override open func setTitle(_ title: String?, forSegmentAt segment: Int) {
        precondition(segment < itemTitles.count, "segment index out of range")
        if let titleText = title {
            super.setTitle(titleText, forSegmentAt: segment)

            itemTitles[segment] = titleText
            itemLabels[segment].text = titleText
        }
    }

    override open func titleForSegment(at segment: Int) -> String? {
        precondition(segment < itemTitles.count, "segment index out of range")
        return itemTitles[segment]
    }
}

// MARK: - Managing Segments
extension SegmentedControl {
    @available(*, unavailable)
    override open func insertSegment(with image: UIImage?, at segment: Int, animated: Bool) {
        fatalError("Image segment control is not supported yet")
    }

    @available(*, unavailable)
    override open func insertSegment(withTitle title: String!, at segment: Int, animated: Bool) {
        fatalError("Not implemented")
    }

    override open var numberOfSegments: Int {
        return itemTitles.count
    }

    override open func removeAllSegments() {
        setupWithTitles([])
    }

    @available(*, unavailable)
    override open func removeSegment(at segment: Int, animated: Bool) {
        fatalError("Not implemented")
    }

    override open var selectedSegmentIndex: Int {
        didSet {
            updateSelectedIndex(selectedSegmentIndex)
            previousSelectedIndex = selectedSegmentIndex
        }
    }
}

// MARK: - Managing Segment Behavior and Appearance
extension SegmentedControl {
    @available(*, unavailable)
    override open var isMomentary: Bool {
        didSet {
            fatalError("Not implemented")
        }
    }

    override open func setEnabled(_ enabled: Bool, forSegmentAt segment: Int) {
        super.setEnabled(enabled, forSegmentAt: segment)

        precondition(segment < itemTitles.count, "segment is out of range")
        itemLabels[segment].isEnabled = false
    }

    override open func isEnabledForSegment(at segment: Int) -> Bool {
        return super.isEnabledForSegment(at: segment)
    }

    @available(*, unavailable)
    override open func setContentOffset(_ offset: CGSize, forSegmentAt segment: Int) {
        fatalError("Not implemented")
    }

    @available(*, unavailable)
    override open func contentOffsetForSegment(at segment: Int) -> CGSize {
        fatalError("Not implemented")
    }

    @available(*, unavailable)
    override open func setWidth(_ width: CGFloat, forSegmentAt segment: Int) {
        fatalError("Not implemented")
    }

    @available(*, unavailable)
    override open func widthForSegment(at segment: Int) -> CGFloat {
        fatalError("Not implemented")
    }

    override open var apportionsSegmentWidthsByContent: Bool {
        didSet {
            fatalError("Not implemented")
        }
    }
}

// MARK: - Helper
private extension SegmentedControl {
	// Creators
    /// Create a title label, common setups.
    ///
    /// - Parameter title: title string
    /// - Returns: a new UILabel instance
	func itemLabelWithTitle(_ title: String) -> UILabel {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		label.text = title
		label.textAlignment = .center
		label.font = titleFont
		label.textColor = titleUnSelectedColor ?? borderColor

		return label
	}

    /// Create a separator line view
    ///
    /// - Returns: a new UIView instance
	func itemSeparatorView() -> UIView {
		let separator = UIView()
		separator.translatesAutoresizingMaskIntoConstraints = false

		separator.backgroundColor = borderColor

		return separator
	}

    /// Add a fade in/out transition animation for UILabel
    ///
    /// - Parameter label: label that needs a fade in/out animation
	func addFadeTransitionAnimationForLabel(_ label: UILabel?) {
		let textAnimation = CATransition()
		textAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		textAnimation.type = CATransitionType.fade
		textAnimation.duration = shouldBeAnimated ? animationDuration : 0.0

		label?.layer.add(textAnimation, forKey: "TextFadeAnimation")
	}

	// Others
    /// Perform animation for updating selected index
    ///
    /// - Parameter index: index new selected index
	func updateSelectedIndex(_ index: Int) {
		var previousLabel: UILabel?
		if previousSelectedIndex >= 0 {
			previousLabel = itemLabels[previousSelectedIndex]
		}
		let currentLabel = itemLabels[index]

		NSLayoutConstraint.deactivate([underScoreLeadingConstraint!, underScoreTrailingConstraint!])

		underScoreLeadingConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .leading, relatedBy: .equal, toItem: currentLabel, attribute: .leading, multiplier: 1.0, constant: 0.0)
		underScoreTrailingConstraint = NSLayoutConstraint(item: selectedUnderScoreView, attribute: .trailing, relatedBy: .equal, toItem: currentLabel, attribute: .trailing, multiplier: 1.0, constant: 0.0)

		NSLayoutConstraint.activate([underScoreLeadingConstraint!, underScoreTrailingConstraint!])

		// If there's no selected index, means it's the first time selection, update width and centerX without animation
		if previousSelectedIndex == -1 {
			self.layoutIfNeeded()
		}

		underScoreHeightConstraint?.constant = underScoreHeight

		addFadeTransitionAnimationForLabel(previousLabel)
		addFadeTransitionAnimationForLabel(currentLabel)

		UIView.animate(withDuration: shouldBeAnimated ? animationDuration : 0.0, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: .beginFromCurrentState, animations: { () -> Void in
			previousLabel?.textColor = self.titleUnSelectedColor ?? self.borderColor
			currentLabel.textColor = self.titleSelectedColor ?? self.tintColor

			self.layoutIfNeeded()
		}, completion: nil)
	}
}

private extension SegmentedControl {
	@objc
    func zh_selectedIndexChanged(_ sender: AnyObject) {
		if let segmentedControl = sender as? UISegmentedControl {
			updateSelectedIndex(segmentedControl.selectedSegmentIndex)
			previousSelectedIndex = segmentedControl.selectedSegmentIndex
		}
	}
}
