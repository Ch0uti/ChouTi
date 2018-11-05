//
//  AlertView.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-05.
//
//

import UIKit

/**
*  Alert View mimics UIAlertController.view
*/
@available(iOS 9.0, *)
open class AlertView: UIView {
    /// The preferred maximum width (in points) for alert view
    open var preferredWidth: CGFloat = 270.0

    /// The title of the alert.
    open var title: String? {
        didSet {
			titleLabel.isHidden = title == nil
            titleLabel.setText(title, withFadeTransitionAnimation: 0.25)
        }
    }

    /// Descriptive text that provides more details about the reason for the alert.
    open var message: String? {
        didSet {
			messageLabel.isHidden = message == nil
            messageLabel.setText(message, withFadeTransitionAnimation: 0.25)
        }
    }

    /// Background view for alert view, default is blur view with extra light effect
    open var backgroundView: UIView! {
        didSet {
            if let oldBackgroundView = oldValue {
                oldBackgroundView.removeFromSuperview()
            }

            if backgroundView == nil {
                backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
            }

            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            insertSubview(backgroundView, at: 0)

            setupBackgroundViewConstraints()
        }
    }

    /// Title label exposed, don't set its text, use `title` instead
    public let titleLabel = UILabel()

    /// Message label exposed, don't set its text, use `message` instead
    public let messageLabel = UILabel()

    /// Vertical spacing between title label and message label
    open var titleMessageVerticalSpacing: CGFloat = 8.0 {
        didSet {
            labelsStackView.spacing = titleMessageVerticalSpacing
        }
    }

    /// Spacing between buttons
    open var buttonSpacing: CGFloat = 8.0 {
        didSet {
            actionButtonsStackView.spacing = buttonSpacing
        }
    }

    /// Vertical spacing between message label and buttons
    open var labelButtonVerticalSpacing: CGFloat = 24.0 {
        didSet {
            containerStackView.spacing = labelButtonVerticalSpacing
        }
    }

    /// Vertical stack view for title and message labels
    private let labelsStackView = UIStackView()

    /// Horizontal (less than 2 buttons) or Vertical (like an action sheet, more than 2 buttons) stack view for buttons
    private let actionButtonsStackView = UIStackView()

    /// Container stack view for labels and actions
    private let containerStackView = UIStackView()

    /// The actions that the user can take in response to the alert. (read-only)
    open private(set) var actions = [AlertAction]() {
        didSet {
            actionButtonsStackView.isHidden = actions.isEmpty
        }
    }

    open override var layoutMargins: UIEdgeInsets {
        didSet {
            titleLabel.preferredMaxLayoutWidth = preferredWidth - layoutMargins.left - layoutMargins.right
            messageLabel.preferredMaxLayoutWidth = preferredWidth - layoutMargins.left - layoutMargins.right
        }
    }

    /**
     Creates and returns a view for displaying an alert to the user.
     
     - parameter title:   The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
     - parameter message: Descriptive text that provides additional details about the reason for the alert.
     
     - returns: An initialized alert view object.
     */
    public convenience init(title: String?, message: String?) {
        self.init()

        // defer
        defer {
            self.title = title
            self.message = message
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = 16.0
        layoutMargins = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

        backgroundView = nil // this triggers to setup default background view

        // Labels
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.preferredMaxLayoutWidth = preferredWidth - layoutMargins.left - layoutMargins.right

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.textAlignment = .center
        messageLabel.setContentHuggingPriority(.required, for: .vertical)
        messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        messageLabel.preferredMaxLayoutWidth = preferredWidth - layoutMargins.left - layoutMargins.right

        labelsStackView.axis = .vertical
        labelsStackView.distribution = .equalSpacing
        labelsStackView.spacing = titleMessageVerticalSpacing
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(messageLabel)

        // Action Buttons
        actionButtonsStackView.axis = .horizontal
        actionButtonsStackView.distribution = .fillEqually
        actionButtonsStackView.spacing = buttonSpacing
        actionButtonsStackView.isHidden = true // there's no actions, set to hidden by default

        // Container
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.spacing = labelButtonVerticalSpacing

        containerStackView.addArrangedSubview(labelsStackView)
        containerStackView.addArrangedSubview(actionButtonsStackView)

        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
    }

    private func setupConstraints() {
        setupBackgroundViewConstraints()

		let views = [
            "containerStackView": containerStackView
		]

        var constraints = [NSLayoutConstraint]()

        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[containerStackView]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[containerStackView]-|", options: [], metrics: nil, views: views)

        NSLayoutConstraint.activate(constraints)
    }

    private func setupBackgroundViewConstraints() {
		let views: [String: UIView] = [
            "backgroundView": backgroundView!
		]

        var constraints = [NSLayoutConstraint]()

        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|", options: [], metrics: nil, views: views)

        NSLayoutConstraint.activate(constraints)
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: preferredWidth, height: UIView.noIntrinsicMetric)
    }

    /**
     Attaches an action object to the alert view
     
     - parameter action: The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
     */
    open func addAction(_ action: AlertAction) {
        if actions.contains(action) {
            NSLog("Warning: adding duplicated action: \(action)")
            return
        }

        actions.append(action)

        // Setup default button height for 44.0
        action.button.translatesAutoresizingMaskIntoConstraints = false
        action.button.constrainTo(height: 44).priority = UILayoutPriority(500)
        actionButtonsStackView.addArrangedSubview(action.button)

        if actions.count > 2 {
            actionButtonsStackView.axis = .vertical
        }
    }
}
