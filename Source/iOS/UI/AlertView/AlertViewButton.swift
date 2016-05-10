//
//  AlertViewButton.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-05.
//
//

import UIKit

/// Buttons on alert view
public class AlertViewButton: Button {
    /// AlertAction binded to this button
    weak var alertAction: AlertAction? {
        didSet {
            guard let alertAction = alertAction else {
                NSLog("Error: alert action should not be set to nil")
                assertionFailure("Error: alert action should not be set to nil")
                return
            }
			
			enabled = alertAction.enabled
            setTitle(alertAction.title, forState: .Normal)
            updateButtonStyle()
        }
    }
    
    /**
     Create and return an alert view button.
     
     - parameter alertAction: AlertAction object to configure this button.
     
     - returns: A new alert view button.
     */
    public required convenience init(alertAction: AlertAction) {
        self.init()
		
        defer {
            self.alertAction = alertAction
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setCornerRadius(.HalfCircle, forState: .Normal)
        
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.58
    }
    
    private func updateButtonStyle() {
        guard let alertAction = alertAction else {
            print("Warning: alertAction is nil")
            return
        }
        
        AlertViewButton.buttonAppearanceConfigurationForAlertActionStyle[alertAction.style]?(self)
    }
}

// MARK: - AlertViewButton Appearance Customization
extension AlertViewButton {
    /// Default button appearance
    private static var buttonAppearanceConfigurationForAlertActionStyle: [UIAlertActionStyle : (AlertViewButton -> Void)] = {[
        .Default : { button in
            button.titleLabel?.font = UIFont.systemFontOfSize(17)
            button.setBorderWidth(0.0, forState: .Normal)
            button.setBackgroundImageWithColor(button.tintColor, forState: .Normal)
            button.setBackgroundImageWithColor(button.tintColor.darkerColor(), forState: .Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        },
        
        .Cancel : { button in
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
            button.setBorderWidth(2.0, forState: .Normal)
            button.setBackgroundImageWithColor(UIColor.clearColor(), forState: .Normal)
            button.setTitleColor(button.tintColor, forState: .Normal)
            button.setTitleColor(button.tintColor.darkerColor(), forState: .Highlighted)
            button.setBorderColor(button.tintColor, forState: .Normal)
            button.setBorderColor(button.tintColor.darkerColor(), forState: .Highlighted)
        },
        
        .Destructive : { button in
            button.titleLabel?.font = UIFont.systemFontOfSize(17)
            button.setBorderWidth(0.0, forState: .Normal)
            let dangerRedColor = UIColor(red:0.75, green:0.15, blue:0.17, alpha:1.00)
            button.setBackgroundImageWithColor(dangerRedColor, forState: .Normal)
            button.setBackgroundImageWithColor(dangerRedColor.darkerColor(), forState: .Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
    ]}()
    
    /**
     Set button appearance configuration for alert action style
     
     - parameter configuration:    button appearance configuration, this block has no return value and takes a button object as its only parameter. You can configure button title, color for different states. You can set button's height by adding a height constraint with 500 priority or above, setting bounds has no effects.
     - parameter alertActionStyle: UIAlertActionStyle
     */
    public static func setButtonAppearanceConfiguration(configuration: (AlertViewButton -> Void), forAlertActionStyle alertActionStyle: UIAlertActionStyle) {
        AlertViewButton.buttonAppearanceConfigurationForAlertActionStyle[alertActionStyle] = configuration
    }
}
