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
public class AlertView: UIView {
    /// The preferred maximum width (in points) for alert view
    public var preferredWidth: CGFloat = 270.0
    
    /// The title of the alert.
    public var title: String? {
        didSet {
            if title == nil {
                titleLabel.hidden = true
            }
            titleLabel.text = title
        }
    }
    
    /// Descriptive text that provides more details about the reason for the alert.
    public var message: String? {
        didSet {
            if message == nil {
                messageLabel.hidden = true
            }
            messageLabel.text = message
        }
    }
    
    /// Background view for alert view, default is blur view with extra light effect
    public var backgroundView: UIView! {
        didSet {
            if let oldBackgroundView = oldValue {
                oldBackgroundView.removeFromSuperview()
            }
            
            if backgroundView == nil {
                backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
            }
            
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            insertSubview(backgroundView, atIndex: 0)
            
            setupBackgroundViewConstraints()
        }
    }
    
    /// Title label exposed, don't set its text, use `title` instead
    public let titleLabel = UILabel()
    
    /// Message label exposed, don't set its text, use `message` instead
    public let messageLabel = UILabel()
    
    /// Vertical spacing between title label and message label
    public var titleMessageVerticalSpacing: CGFloat = 8.0 {
        didSet {
            labelsStackView.spacing = titleMessageVerticalSpacing
        }
    }
    
    /// Spacing between buttons
    public var buttonSpacing: CGFloat = 8.0 {
        didSet {
            actionButtonsStackView.spacing = buttonSpacing
        }
    }
    
    /// Vertical spacing between message label and buttons
    public var labelButtonVerticalSpacing: CGFloat = 24.0 {
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
    public private(set) var actions = [AlertAction]() {
        didSet {
            actionButtonsStackView.hidden = actions.isEmpty
        }
    }
    
    public override var layoutMargins: UIEdgeInsets {
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
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.textAlignment = .Center
        titleLabel.setContentHuggingPriority(1000, forAxis: .Vertical)
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        titleLabel.preferredMaxLayoutWidth = preferredWidth - layoutMargins.left - layoutMargins.right
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFontOfSize(13)
        messageLabel.textAlignment = .Center
        messageLabel.setContentHuggingPriority(1000, forAxis: .Vertical)
        messageLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        messageLabel.preferredMaxLayoutWidth = preferredWidth - layoutMargins.left - layoutMargins.right
        
        labelsStackView.axis = .Vertical
        labelsStackView.distribution = .EqualSpacing
        labelsStackView.spacing = titleMessageVerticalSpacing
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(messageLabel)
        
        // Action Buttons
        actionButtonsStackView.axis = .Horizontal
        actionButtonsStackView.distribution = .FillEqually
        actionButtonsStackView.spacing = buttonSpacing
        actionButtonsStackView.hidden = true // there's no actions, set to hidden by default
        
        // Container
        containerStackView.axis = .Vertical
        containerStackView.distribution = .EqualSpacing
        containerStackView.spacing = labelButtonVerticalSpacing
        
        containerStackView.addArrangedSubview(labelsStackView)
        containerStackView.addArrangedSubview(actionButtonsStackView)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
    }

    private func setupConstraints() {
        setupBackgroundViewConstraints()
        
        let views = [
            "containerStackView" : containerStackView
        ]

        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-[containerStackView]-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[containerStackView]-|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    private func setupBackgroundViewConstraints() {
        let views = [
            "backgroundView" : backgroundView
        ]
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[backgroundView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[backgroundView]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSize(width: preferredWidth, height: UIViewNoIntrinsicMetric)
    }
    
    /**
     Attaches an action object to the alert view
     
     - parameter action: The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
     */
    public func addAction(action: AlertAction) {
        if actions.contains(action) {
            NSLog("Warning: adding duplicated action: \(action)")
            return
        }
        
        actions.append(action)
        
        // Setup default button height for 44.0 
        action.button.constrainToHeight(44).priority = 500
        actionButtonsStackView.addArrangedSubview(action.button)
        
        if actions.count > 2 {
            actionButtonsStackView.axis = .Vertical
        }
    }
}
