//
//  AlertAction.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-05.
//
//

import UIKit

/// This class mimics UIAlertAction.
open class AlertAction: Equatable {
    /// The title of the action’s button. (read-only)
    public let title: String?
    
    /// The style that is applied to the action’s button. (read-only)
    public let style: UIAlertAction.Style
    
    /// Action handler
    let handler: ((AlertAction) -> Void)?
    
    /// Button associated with this alert action
    public let button: UIButton
    
    /// A Boolean value indicating whether the action is currently enabled.
    open var enabled: Bool = true
    
    /**
     Create and return an action with the specified title and behavior.
     
     - parameter title:   The text to use for the button title. The value you specify should be localized for the user’s current language.
     - parameter style:   Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button. For a list of possible values, see the constants in UIAlertActionStyle.
     - parameter handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
     
     - returns: A new alert action object.
     */
    public init(title: String?, style: UIAlertAction.Style, handler: ((AlertAction) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
        let alertActionButton = AlertViewButton()
        self.button = alertActionButton
        
        alertActionButton.alertAction = self
        alertActionButton.addTarget(self, action: #selector(AlertAction.buttonTapped(_:)), for: .touchUpInside)
    }
    
    /**
     Create and return an action with customized button and action handler.
     
     - parameter title:   The action title, this is not associated with button title, you should setup button title correctly.
     - parameter button:  Customized button.
     - parameter handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
     
     - returns: A new alert action object.
     */
    public init(title: String?, button: UIButton, handler: ((AlertAction) -> Void)?) {
        self.title = title
        self.style = .default
        self.handler = handler
        self.button = button
        
        button.addTarget(self, action: #selector(AlertAction.buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        performActionHandler()
    }
    
    /**
     Try to perform action handler, if enabled is false, nothing happens.
     */
    func performActionHandler() {
        if enabled {
            handler?(self)
        }
    }
}

public func == (lhs: AlertAction, rhs: AlertAction) -> Bool {
    return (lhs.title == rhs.title) && (lhs.style == rhs.style) && (lhs.button == rhs.button)
}
