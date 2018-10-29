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
    fileprivate let animator = ScalePresentingAnimator()
    
    /// The title of the alert.
    open override var title: String? {
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
        get { return alertView.actions }
    }
    
    /// Override preferredContentSize to make sure view layout is always updated and centered
    open override var preferredContentSize: CGSize {
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
    
    /// width constraint for view
    fileprivate var widthConstraint: NSLayoutConstraint?
    
    /// height constraint for view
    fileprivate var heightConstraint: NSLayoutConstraint?
	
	/// An UIWindow instance which its rootViewController is presenting self.
	fileprivate var alertWindow: UIWindow?
	
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
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit() {
        animator.presentingInitialScaleFactor = 1.2
        animator.dismissingFinalScaleFactor = 0.95
        
        // Setup customized presenting/dismissing transitioning delegate
        modalPresentationStyle = .custom
        transitioningDelegate = animator
    }
        
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initially I want to set self.view = alertView.
        // However, you cannot set layoutMargins to the root view of a view controller.
        // Hence, I have to add it as a subview
        // Reference: http://stackoverflow.com/a/31757312/3164091
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.constrainToFullSizeInSuperview()
    }
	
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // at this moment, view size is about to be determined by presenting animator, preferred content size should be updated.
        updatePreferredContentSize()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Use constraint-based layout to center alert view
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constrainToCenterInSuperview()
        widthConstraint = view.constrainTo(width: preferredContentSize.width)
        heightConstraint = view.constrainTo(height: preferredContentSize.height)
    }
	
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
		
		alertWindow?.isHidden = true
		alertWindow = nil
		
        // restore to use frame (default state)
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
    
    @objc func buttonTapped(_ button: UIButton) {
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
extension AlertController {
    /**
     Update controller's preferred content size from action view's size
     */
    fileprivate func updatePreferredContentSize() {
        preferredContentSize = alertView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

extension AlertController {
	/**
	Show this alert controller without a presenting controller, this is also useful when present alert above a presented view controller.
	Ref: http://www.thecave.com/2015/09/28/how-to-present-an-alert-view-using-uialertcontroller-when-you-dont-have-a-view-controller/
	Ref: https://github.com/kirbyt/WPSKit/blob/master/WPSKit/UIKit/WPSAlertController.m
	
	- parameter animated:   whether the alert controller is presented animated
	- parameter completion: completion block
	*/
	public func show(animated: Bool, completion: (() -> Void)? = nil) {
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
