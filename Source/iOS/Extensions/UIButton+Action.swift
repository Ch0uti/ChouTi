//
//  UIButton+Action.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-07-03.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit

public extension UIButton {
    private class ButtonAction {
        var action: UIButton -> Void
        
        init(action: UIButton -> Void) {
            self.action = action
        }
    }
    
    private struct AssociatedKeys {
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
    public convenience init(action: UIButton -> Void) {
        self.init()
        buttonAction = ButtonAction(action: action)
        addTarget(self, action: #selector(UIButton.handleAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    /**
     Initialize a UIButton with the given frame, using the given closure as the .TouchUpInside target/action event.
     
     - parameter frame:  The frame of the button.
     - parameter action: the closure to execute upon button press.
     
     - returns: An initialized UIButton.
     */
    public convenience init(frame: CGRect, action: UIButton -> Void) {
        self.init(frame: frame)
        buttonAction = ButtonAction(action: action)
        addTarget(self, action: #selector(UIButton.handleAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    /**
     Initialize a UIButton with the given button type, using the given closure as the .TouchUpInside target/action event.
     
     - parameter buttonType: The button type.
     - parameter action:     the closure to execute upon button press.
     
     - returns: An initialized UIButton.
     */
    public convenience init(buttonType: UIButtonType, action: UIButton -> Void) {
        self.init(type: buttonType)
        buttonAction = ButtonAction(action: action)
        addTarget(self, action: #selector(UIButton.handleAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    /**
     Adds the given closure as the button's target action
     
     - parameter controlEvents: The UIControlEvents upon which to execute this action.
     - parameter action:        The action closure to execute.
     */
    public func addTarget(controlEvents controlEvents: UIControlEvents, action: UIButton -> Void) {
        buttonAction = ButtonAction(action: action)
        addTarget(self, action: #selector(UIButton.handleAction(_:)), forControlEvents: controlEvents)
    }
    
    private dynamic func handleAction(button: UIButton) {
        buttonAction?.action(button)
    }
}
