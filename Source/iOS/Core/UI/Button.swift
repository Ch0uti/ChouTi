//
//  Button.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-06.
//
//

import UIKit

/// Button With Extra Presentation Styles
/// You can set borderColor, borderWidth, cornerRadius and backgroundColor for different states
open class Button: UIButton {
    
    /**
     Corner radius attribute, used in CornerRadius .Relative case
     
     - Width:  Width
     - Height: Height
     */
    public enum Attribute {
        case width
        case height
    }
    
    /**
     Corner radius option
     
     - Absolute:   absolute corner radius
     - Relative:   relative corner radius, calculated by percetage multiply by width or height
     - HalfCircle: half-circle, capsule like
     */
    public enum CornerRadius {
        case absolute(CGFloat)
        case relative(percent: CGFloat, attribute: Attribute)
        case halfCircle
        
        public func cornerRadiusValue(forView view: UIView) -> CGFloat {
            switch self {
            case .absolute(let cornerRadius):
                return cornerRadius
                
            case .relative(percent: let percent, attribute: let attribute):
                switch attribute {
                case .width:
                    return percent * view.bounds.width
                case .height:
                    return percent * view.bounds.height
                }
                
            case .halfCircle:
                return 0.5 * min(view.bounds.width, view.bounds.height)
            }
        }
    }
    
    // MARK: - Storing Extra Presentation Styles
    fileprivate var borderColorForState = [UInt : UIColor]()
    fileprivate var borderWidthForState = [UInt : CGFloat]()
    fileprivate var cornerRadiusForState = [UInt : CornerRadius]()
    fileprivate var backgroundImageColorForState = [UInt : UIColor]()
    
    // MARK: - Overriden
    open override var isHighlighted: Bool { didSet { refreshBorderStyles() } }
    open override var isEnabled: Bool { didSet { refreshBorderStyles() } }
    open override var isSelected: Bool { didSet { refreshBorderStyles() } }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        refreshBorderStyles()
    }
}

// MARK: - Configuring Button Presentation
extension Button {
    // MARK: - Setting Extra Presentation Styles
    
    /**
     Set the border color to use for the specified state.
     
     - parameter color: The border color to use for the specified state.
     - parameter state: The state that uses the specified border color. The possible values are described in UIControlState.
     */
    public func setBorderColor(_ color: UIColor?, forState state: UIControlState) {
        if borderColorForState[state.rawValue] <-? color { refreshBorderStyles() }
    }
    
    /**
     Set the border width to use for the specified state.
     
     - parameter width: The border width to use for the specified state.
     - parameter state: The state that uses the specified border width. The possible values are described in UIControlState.
     */
    public func setBorderWidth(_ width: CGFloat?, forState state: UIControlState) {
        if borderWidthForState[state.rawValue] <-? width { refreshBorderStyles() }
    }
    
    /**
     Set the corner radius to use for the specified state. `clipsToBounds` is set to true.
     
     - parameter cornerRadius: The corner radius to use for the specified state.
     - parameter state:        The state that uses the specified corner radius. The possible values are described in UIControlState.
     */
    public func setCornerRadius(_ cornerRadius: CornerRadius?, forState state: UIControlState) {
        clipsToBounds = true
        if cornerRadiusForState[state.rawValue] <-? cornerRadius { refreshBorderStyles() }
    }
    
    /**
     Set the background image with color to use for the specified state.
     
     - parameter color: The color for background image to use for the specified state.
     - parameter state: The state that uses the specified background image color. The possible values are described in UIControlState.
     */
    public override func setBackgroundImageWithColor(_ color: UIColor?, forState state: UIControlState) {
        if backgroundImageColorForState[state.rawValue] <-? color {
            if let color = color {
                setBackgroundImage(UIImage.imageWithColor(color), for: state)
            } else {
                setBackgroundImage(nil, for: state)
            }
        }
    }
    
    // MARK: - Getting Extra Presentation Styles
    
    /**
     Returns the border color associated with the specified state.
     
     - parameter state: The state that uses the border color. The possible values are described in UIControlState.
     
     - returns: The border color for the specified state. If no border color has been set for the specific state, this method returns the border color associated with the UIControlStateNormal state. If no border color has been set for the UIControlStateNormal state, nil is returned.
     */
    public func borderColorForState(_ state: UIControlState) -> UIColor? {
        return borderColorForState[state.rawValue] ?? borderColorForState[UIControlState.normal.rawValue]
    }
    
    /**
     Returns the border width used for a state.
     
     - parameter state: The state that uses the border width. The possible values are described in UIControlState.
     
     - returns: The border width for the specified state. If there's no border width is set for the state, border width for normal state is returned, otherwise, nil is returned.
     */
    public func borderWidthForState(_ state: UIControlState) -> CGFloat? {
        return borderWidthForState[state.rawValue] ?? borderWidthForState[UIControlState.normal.rawValue]
    }
    
    /**
     Returns the corner radius used for a state.
     
     - parameter state: The state that uses the corner radius. The possible values are described in UIControlState.
     
     - returns: The corner radius for the specified state. If there's no corner radius is set for the state, corner radius for normal state is returned, otherwise, nil is returned.
     */
    public func cornerRadiusForState(_ state: UIControlState) -> CornerRadius? {
        return cornerRadiusForState[state.rawValue] ?? cornerRadiusForState[UIControlState.normal.rawValue]
    }
    
    /**
     Returns the background image color associated with the specified state.
     
     - parameter state: The state that uses the background image color. The possible values are described in UIControlState.
     
     - returns: The background image color for the specified state. If no background image color has been set for the specific state, this method returns the background image color associated with the UIControlStateNormal state. If no background image color has been set for the UIControlStateNormal state, nil is returned.
     */
    public func backgroundImageColorForState(_ state: UIControlState) -> UIColor? {
        return backgroundImageColorForState[state.rawValue] ?? backgroundImageColorForState[UIControlState.normal.rawValue]
    }
}

// MARK: - Getting the Current State
extension Button {
    /// The current border color that is displayed on the button. (read-only)
    public var currentBorderColor: UIColor? { return (layer.borderColor != nil) ? UIColor(cgColor: layer.borderColor!) : nil }
    
    /// The current border width that is displayed on the button. (read-only)
    public var currentBorderWidth: CGFloat { return layer.borderWidth }
    
    /// The current corner radius that is displayed on the button. (read-only)
    public var currentCornerRadius: CornerRadius {
        return cornerRadiusForState[state.rawValue] ?? cornerRadiusForState[UIControlState.normal.rawValue] ?? .absolute(layer.cornerRadius)
    }
    
    /// The current background image color that is displayed on the button. (read-only)
    public var currentBackgroundImageColor: UIColor? {
        return backgroundImageColorForState[state.rawValue] ?? backgroundImageColorForState[UIControlState.normal.rawValue]
    }
}

// MARK: - Private Helpers
extension Button {
    
    // MARK: - Convenient Values
    fileprivate var normalBorderColor: UIColor? { return borderColorForState[UIControlState.normal.rawValue] }
    fileprivate var highlightedBorderColor: UIColor? { return borderColorForState[UIControlState.highlighted.rawValue] }
    fileprivate var disabledBorderColor: UIColor? { return borderColorForState[UIControlState.disabled.rawValue] }
    fileprivate var selectedBorderColor: UIColor? { return borderColorForState[UIControlState.selected.rawValue] }
    
    fileprivate var normalBorderWidth: CGFloat? { return borderWidthForState[UIControlState.normal.rawValue] }
    fileprivate var highlightedBorderWidth: CGFloat? { return borderWidthForState[UIControlState.highlighted.rawValue] }
    fileprivate var disabledBorderWidth: CGFloat? { return borderWidthForState[UIControlState.disabled.rawValue] }
    fileprivate var selectedBorderWidth: CGFloat? { return borderWidthForState[UIControlState.selected.rawValue] }
    
    fileprivate var normalCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.normal.rawValue]?.cornerRadiusValue(forView: self) }
    fileprivate var highlightedCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.highlighted.rawValue]?.cornerRadiusValue(forView: self) }
    fileprivate var disabledCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.disabled.rawValue]?.cornerRadiusValue(forView: self) }
    fileprivate var selectedCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.selected.rawValue]?.cornerRadiusValue(forView: self) }
    
    /**
     Refresh customized styles
     */
    fileprivate func refreshBorderStyles() {
        // add a fade transition.
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.075
        
        defer {
            layer.add(transition, forKey: kCATransition)
        }
        
        if state == .highlighted {
            layer.borderColor =? highlightedBorderColor?.cgColor ?? normalBorderColor?.cgColor
            layer.borderWidth =? highlightedBorderWidth ?? normalBorderWidth
            layer.cornerRadius =? highlightedCornerRadius ?? normalCornerRadius
        } else if state == .disabled {
            layer.borderColor =? disabledBorderColor?.cgColor ?? normalBorderColor?.cgColor
            layer.borderWidth =? disabledBorderWidth ?? normalBorderWidth
            layer.cornerRadius =? disabledCornerRadius ?? normalCornerRadius
        } else if state == .selected {
            layer.borderColor =? selectedBorderColor?.cgColor ?? normalBorderColor?.cgColor
            layer.borderWidth =? selectedBorderWidth ?? normalBorderWidth
            layer.cornerRadius =? selectedCornerRadius ?? normalCornerRadius
        } else {
            // prolong the fade transition, this mimics UIButtonType.System behaviors
            transition.duration = 0.25
            
            // Defaults to .Normal state
            layer.borderColor =? normalBorderColor?.cgColor
            layer.borderWidth =? normalBorderWidth
            layer.cornerRadius =? normalCornerRadius
        }
    }
	
	// TODO: Transparent title color
	// Reference: https://github.com/purrrminator/AKStencilButton/blob/master/AKStencilButton.m
	// http://stackoverflow.com/questions/27458101/transparent-uibutton-title
	// http://stackoverflow.com/questions/23515100/ios-uibutton-with-transparent-title-on-white-background
//    private func refreshClearTitleMask() {
////        titleLabel?.backgroundColor = UIColor.clearColor()
//        let text = titleLabel?.text
//        let font = titleLabel?.font
//        
//        let attributes = [NSFontAttributeName : titleLabel?.font]
//        let textSize = text.
//    }
}

// MARK: - Button.CornerRadius : Equatable
extension Button.CornerRadius : Equatable {}
public func == (lhs: Button.CornerRadius, rhs: Button.CornerRadius) -> Bool {
    switch (lhs, rhs) {
    case (.absolute(let lValue), .absolute(let rValue)):
        return lValue == rValue
    case (.relative(let lPercent, let lAttribute), .relative(let rPercent, let rAttribute)):
        return (lPercent == rPercent) && (lAttribute == rAttribute)
    case (.halfCircle, .halfCircle):
        return true
    default:
        return false
    }
}

// MARK: <-? Non-equal Assignment Operator
infix operator <-? : AssignmentPrecedence

/**
 Nonequal Assignment Operator
 If lhs and rhs are equal, no assignment
 
 - parameter lhs: a variable of type T: Equatable
 - parameter rhs: a variable of type T: Equatable
 
 - returns: ture if lhs is assigned, false otherwise
 */
private func <-? <T: Equatable>(lhs: inout T?, rhs: T?) -> Bool {
    if lhs == rhs { return false }
    lhs = rhs
    return true
}
