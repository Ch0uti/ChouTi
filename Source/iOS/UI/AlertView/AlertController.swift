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
public class AlertController: UIViewController {
    
    /// ActionView will be presented
    public let actionView = AlertView()
    
    /// Scale presenting/dismissing animator
    private let animator = ScalePresentingAnimator()
    
    /// The title of the alert.
    public override var title: String? {
        get { return actionView.title }
        set { actionView.title = newValue }
    }
    
    /// Descriptive text that provides more details about the reason for the alert.
    public var message: String? {
        get { return actionView.message }
        set { actionView.message = newValue }
    }
    
    /// The actions that the user can take in response to the alert. (read-only)
    public var actions: [AlertAction] {
        get { return actionView.actions }
    }
    
    /**
     Creates and returns a view controller for displaying an alert to the user.
     
     - parameter title:   The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
     - parameter message: Descriptive text that provides additional details about the reason for the alert.
     
     - returns: An initialized alert controller object.
     */
    public convenience init(title: String?, message: String?) {
        self.init()
        actionView.title = title
        actionView.message = message
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        animator.presentingInitialScaleFactor = 1.2
        animator.dismissingFinalScaleFactor = 0.95
        
        // Setup customized presenting/dismissing transitioning delegate
        modalPresentationStyle = .Custom
        transitioningDelegate = animator
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initially I want to set self.view = actionView.
        // However, you cannot set layoutMargins to the root view of a view controller.
        // Hence, I have to add it as a subview
        // Reference: http://stackoverflow.com/a/31757312/3164091
        view.addSubview(actionView)
        actionView.constrainToFullSizeInSuperview()
    }
	
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // at this moment, view size is about to be determined by presenting animator, preferred content size should be updated.
        updatePreferredContentSize()
    }
    
    /**
     Attaches an action object to the alert
     
     - parameter action: The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
     */
    public func addAction(action: AlertAction) {
        // Remove the default target action, handler should be called after dismissing completed
        action.button.removeTarget(action, action: #selector(AlertAction.buttonTapped(_:)), forControlEvents: .TouchUpInside)
        // Add customized action
        action.button.addTarget(self, action: #selector(AlertController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
        
        actionView.addAction(action)
    }
    
    func buttonTapped(button: UIButton) {
        // Call action handler when dismissing completed
        self.dismissViewControllerAnimated(true, completion: { [weak self] in
            self?.actionView.actions.forEach {
                if $0.button == button {
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
    private func updatePreferredContentSize() {
        preferredContentSize = actionView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    }
}
