//
//  UIButton+Action.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-03.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public extension UIButton {
    private class ButtonAction {
        var action: (UIButton) -> Void

        init(action: @escaping (UIButton) -> Void) {
            self.action = action
        }
    }

    private enum AssociatedKeys {
        static var ActionName = "action"
    }

    private var buttonAction: ButtonAction? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionName, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionName) as? ButtonAction }
    }

    /**
     Initialize a UIButton, using the given closure as the .TouchUpInside target/action event.
     
     - parameter action: The closure to execute upon button press.
     
     - returns: An initialized UIButton.
     */
    public convenience init(action: @escaping (UIButton) -> Void) {
        self.init()
        buttonAction = ButtonAction(action: action)
        addTarget(self, action: #selector(UIButton.handleAction(_:)), for: .touchUpInside)
    }

    /**
     Initialize a UIButton with the given frame, using the given closure as the .TouchUpInside target/action event.
     
     - parameter frame:  The frame of the button.
     - parameter action: the closure to execute upon button press.
     
     - returns: An initialized UIButton.
     */
    public convenience init(frame: CGRect, action: @escaping (UIButton) -> Void) {
        self.init(frame: frame)
        buttonAction = ButtonAction(action: action)
        addTarget(self, action: #selector(UIButton.handleAction(_:)), for: .touchUpInside)
    }

    /**
     Initialize a UIButton with the given button type, using the given closure as the .TouchUpInside target/action event.
     
     - parameter buttonType: The button type.
     - parameter action:     the closure to execute upon button press.
     
     - returns: An initialized UIButton.
     */
    public convenience init(buttonType: UIButton.ButtonType, action: @escaping (UIButton) -> Void) {
        self.init(type: buttonType)
        buttonAction = ButtonAction(action: action)
        addTarget(self, action: #selector(UIButton.handleAction(_:)), for: .touchUpInside)
    }

    /**
     Adds the given closure as the button's target action
     
     - parameter controlEvents: The UIControlEvents upon which to execute this action.
     - parameter action:        The action closure to execute.
     */
    public func addTarget(controlEvents: UIControl.Event, action: @escaping (UIButton) -> Void) {
        buttonAction = ButtonAction(action: action)
        addTarget(self, action: #selector(UIButton.handleAction(_:)), for: controlEvents)
    }

    @objc
    private dynamic func handleAction(_ button: UIButton) {
        buttonAction?.action(button)
    }
}
