//
//  Created by Honghao Zhang on 05/05/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

/// Buttons on alert view
open class AlertViewButton: Button {
    /// AlertAction binded to this button
    weak var alertAction: AlertAction? {
        didSet {
            guard let alertAction = alertAction else {
                NSLog("Error: alert action should not be set to nil")
                assertionFailure("Error: alert action should not be set to nil")
                return
            }

			isEnabled = alertAction.enabled
            setTitle(alertAction.title, for: .normal)
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

    override private init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        self.clipsToBounds = true
        setCornerRadius(.halfCircle, forState: .normal)

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
    private static var buttonAppearanceConfigurationForAlertActionStyle: [UIAlertAction.Style: ((AlertViewButton) -> Void)] = {[
        .default: { button in
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.setBorderWidth(0.0, forState: .normal)
            button.setBackgroundImageWithColor(button.tintColor, forState: .normal)
            button.setBackgroundImageWithColor(button.tintColor.darkerColor(), forState: .highlighted)
            button.setTitleColor(UIColor.white, for: .normal)
        },

        .cancel: { button in
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            button.setBorderWidth(2.0, forState: .normal)
            button.setBackgroundImageWithColor(UIColor.clear, forState: .normal)
            button.setTitleColor(button.tintColor, for: .normal)
            button.setTitleColor(button.tintColor.darkerColor(), for: .highlighted)
            button.setBorderColor(button.tintColor, forState: .normal)
            button.setBorderColor(button.tintColor.darkerColor(), forState: .highlighted)
        },

        .destructive: { button in
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.setBorderWidth(0.0, forState: .normal)
            let dangerRedColor = UIColor(red: 0.75, green: 0.15, blue: 0.17, alpha: 1.00)
            button.setBackgroundImageWithColor(dangerRedColor, forState: .normal)
            button.setBackgroundImageWithColor(dangerRedColor.darkerColor(), forState: .highlighted)
            button.setTitleColor(UIColor.white, for: .normal)
        }
    ]}()

    /**
     Set button appearance configuration for alert action style
     
     - parameter configuration:    button appearance configuration, this block has no return value and takes a button object as its only parameter. You can configure button title, color for different states. You can set button's height by adding a height constraint with 500 priority or above, setting bounds has no effects.
     - parameter alertActionStyle: UIAlertActionStyle
     */
    public static func setButtonAppearanceConfiguration(_ configuration: @escaping ((AlertViewButton) -> Void), forAlertActionStyle alertActionStyle: UIAlertAction.Style) {
        AlertViewButton.buttonAppearanceConfigurationForAlertActionStyle[alertActionStyle] = configuration
    }
}
