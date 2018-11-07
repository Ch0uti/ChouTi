//
//  AlertController.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-09.
//
//

import UIKit

/**
 *  A customized alert controller, this class mimics UIAlertController.
 *  Currently, this class only supports Alert style.
 */
@available(iOS 9.0, *)
open class AlertController: UIViewController {

    /// AlertView will be presented
    public let alertView = AlertView()

    /// Scale presenting/dismissing animator
    private let animator = ScalePresentingAnimator()

    /// The title of the alert.
    override open var title: String? {
        get { return alertView.title }
        set {
			alertView.title = newValue
            updatePreferredContentSize()
		}
    }

    /// Descriptive text that provides more details about the reason for the alert.
    open var message: String? {
        get { return alertView.message }
        set {
			alertView.message = newValue
			updatePreferredContentSize()
		}
    }

    /// The actions that the user can take in response to the alert. (read-only)
    open var actions: [AlertAction] {
        return alertView.actions
    }

    /// Override preferredContentSize to make sure view layout is always updated and centered
    override open var preferredContentSize: CGSize {
        didSet {
            guard let widthConstraint = widthConstraint,
				let heightConstraint = heightConstraint,
				presentingViewController != nil else {
                return
            }

            widthConstraint.constant = preferredContentSize.width
            heightConstraint.constant = preferredContentSize.height
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState], animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    /// Width constraint for view
    private var widthConstraint: NSLayoutConstraint?

    /// Height constraint for view
    private var heightConstraint: NSLayoutConstraint?

	/// An UIWindow instance which its rootViewController is presenting self.
	private var alertWindow: UIWindow?

    /**
     Creates and returns a view controller for displaying an alert to the user.
     
     - parameter title:   The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
     - parameter message: Descriptive text that provides additional details about the reason for the alert.
     
     - returns: An initialized alert controller object.
     */
    public convenience init(title: String?, message: String?) {
        self.init()
        alertView.title = title
        alertView.message = message
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        commonInit()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        animator.presentingInitialScaleFactor = 1.2
        animator.dismissingFinalScaleFactor = 0.95

        // Setup customized presenting/dismissing transitioning delegate
        modalPresentationStyle = .custom
        transitioningDelegate = animator
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Initially I want to set self.view = alertView.
        // However, you cannot set layoutMargins to the root view of a view controller.
        // Hence, I have to add it as a subview
        // Reference: http://stackoverflow.com/a/31757312/3164091
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.constrainToFullSizeInSuperview()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // At this moment, view size is about to be determined by presenting animator, preferred content size should be updated.
        updatePreferredContentSize()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Use constraint-based layout to center alert view
        setupConstraints()
    }

    private func setupConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constrainToCenterInSuperview()
        widthConstraint = view.constrainTo(width: preferredContentSize.width)
        heightConstraint = view.constrainTo(height: preferredContentSize.height)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

		alertWindow?.isHidden = true
		alertWindow = nil

        // Restore to use frame (default state)
        view.translatesAutoresizingMaskIntoConstraints = true
    }

    /**
     Attaches an action object to the alert
     
     - parameter action: The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
     */
    open func addAction(_ action: AlertAction) {
        // Remove the default target action, handler should be called after dismissing completed
        action.button.removeTarget(action, action: #selector(AlertAction.buttonTapped(_:)), for: .touchUpInside)
        // Add customized action
        action.button.addTarget(self, action: #selector(AlertController.buttonTapped(_:)), for: .touchUpInside)

        alertView.addAction(action)
    }

    @objc
    func buttonTapped(_ button: UIButton) {
        // Call action handler when dismissing completed
        self.dismiss(animated: true, completion: { [weak self] in
            self?.alertView.actions.forEach {
                if $0.button === button {
                    $0.performActionHandler()
                }
            }
        })
    }
}

@available(iOS 9.0, *)
private extension AlertController {
    /**
     Update controller's preferred content size from action view's size
     */
    func updatePreferredContentSize() {
        preferredContentSize = alertView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

public extension AlertController {
	/**
	Show this alert controller without a presenting controller, this is also useful when present alert above a presented view controller.
	Ref: http://www.thecave.com/2015/09/28/how-to-present-an-alert-view-using-uialertcontroller-when-you-dont-have-a-view-controller/
	Ref: https://github.com/kirbyt/WPSKit/blob/master/WPSKit/UIKit/WPSAlertController.m
	
	- parameter animated:   whether the alert controller is presented animated
	- parameter completion: completion block
	*/
    func show(animated: Bool, completion: (() -> Void)? = nil) {
		let blankViewController = UIViewController()
		blankViewController.view.backgroundColor = UIColor.clear

        // On iOS 9, UIWindow will just have a correct frame.
		let window = UIWindow()

		// On iOS 8, Use applicationFrame to calculate window frame.
		// if #available(iOS 9.0, *) {} else {
		//	let applicationFrame = UIScreen.mainScreen().applicationFrame
		//	window.frame = CGRect(x: 0, y: 0, width: applicationFrame.width, height: applicationFrame.height + applicationFrame.origin.y)
		// }

		window.rootViewController = blankViewController
		window.backgroundColor = UIColor.clear
		window.windowLevel = UIWindow.Level.alert + 1 // +1 is necessary for present above a presented view controller
		window.makeKeyAndVisible()

		alertWindow = window

		blankViewController.present(self, animated: animated, completion: completion)
	}
}
