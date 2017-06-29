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
     Corner radius attribute, used in CornerRadius .relative case.
     
     - Width:  Width
     - Height: Height
     */
    public enum Attribute {
        case width
        case height
    }
    
    /**
     Corner radius option.
     
     - Absolute:   Absolute corner radius.
     - Relative:   Relative corner radius, calculated by percetage multiply by width or height
     - HalfCircle: Half-circle, capsule like
     */
    public enum CornerRadius: Equatable {
        case absolute(CGFloat)
        case relative(percent: CGFloat, attribute: Attribute)
        case halfCircle
        
        public func value(for view: UIView) -> CGFloat {
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
        
        // MARK: - Equatable
        static public func == (lhs: CornerRadius, rhs: CornerRadius) -> Bool {
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
    }
    
    /// If the button appearance transition should be animated. Default value is `true`.
    public var isAnimated: Bool = true
    
    // MARK: - Storing Extra Presentation Styles
    fileprivate var _backgroundColorForState = [UInt : UIColor]()
    fileprivate var backgroundImageColorForState = [UInt : UIColor]()
    fileprivate var transformForState = [UInt : CGAffineTransform]()
    
    // Layer Related
    fileprivate var borderColorForState = [UInt : UIColor]()
    fileprivate var borderWidthForState = [UInt : CGFloat]()
    fileprivate var cornerRadiusForState = [UInt : CornerRadius]()
    
    // Shadow Related
    fileprivate var shadowColorForState = [UInt : UIColor]()
    fileprivate var shadowOpacityForState = [UInt : Float]()
    fileprivate var shadowOffsetForState = [UInt : CGSize]()
    fileprivate var shadowRadiusForState = [UInt : CGFloat]()
    fileprivate var shadowPathForState = [UInt : CGPath]()
    
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
    
    /// Set the background color to use for the specified state.
    ///
    /// - Parameters:
    ///   - color: The background color for the specified state.
    ///   - state: The state that uses the specified background color. The possible values are described in UIControlState.
    public func setBackgroundColor(_ color: UIColor?, forState state: UIControlState) {
        if _backgroundColorForState[state.rawValue] <-? color { refreshBorderStyles() }
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
    
    /// Set the transform to use for the specified state.
    ///
    /// - Parameters:
    ///   - transform: The transform for the specified state.
    ///   - state: The state that uses the specified transform. The possible values are described in UIControlState.
    public func setTransform(_ transform: CGAffineTransform?, forState state: UIControlState) {
        if transformForState[state.rawValue] <-? transform { refreshBorderStyles() }
    }
    
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
     Set the corner radius to use for the specified state.
     
     - parameter cornerRadius: The corner radius to use for the specified state.
     - parameter state:        The state that uses the specified corner radius. The possible values are described in UIControlState.
     */
    public func setCornerRadius(_ cornerRadius: CornerRadius?, forState state: UIControlState) {
        if cornerRadiusForState[state.rawValue] <-? cornerRadius { refreshBorderStyles() }
    }
    
    /// Set the shadow color to use for the specified state. `clipsToBounds` should be `false` to see the effect.
    ///
    /// - Parameters:
    ///   - shadowColor: The shadow color to use for the specified state.
    ///   - state: The state that uses the specified shadow color. The possible values are described in UIControlState.
    public func setShadowColor(_ shadowColor: UIColor?, for state: UIControlState) {
        if shadowColorForState[state.rawValue] <-? shadowColor { refreshBorderStyles() }
    }
    
    /// Set the shadow opacity to use for the specified state. `clipsToBounds` should be `false` to see the effect.
    ///
    /// - Parameters:
    ///   - shadowOpacity: The shadow opacity to use for the specified state.
    ///   - state: The state that uses the specified shadow opacity. The possible values are described in UIControlState.
    public func setShadowOpacity(_ shadowOpacity: Float?, for state: UIControlState) {
        if shadowOpacityForState[state.rawValue] <-? shadowOpacity { refreshBorderStyles() }
    }
    
    /// Set the shadow offset to use for the specified state. `clipsToBounds` should be `false` to see the effect.
    ///
    /// - Parameters:
    ///   - shadowOffset: The shadow offset to use for the specified state.
    ///   - state: The state that uses the specified shadow offset. The possible values are described in UIControlState.
    public func setShadowOffset(_ shadowOffset: CGSize?, for state: UIControlState) {
        if shadowOffsetForState[state.rawValue] <-? shadowOffset { refreshBorderStyles() }
    }
    
    /// Set the shadow radius to use for the specified state. `clipsToBounds` should be `false` to see the effect.
    ///
    /// - Parameters:
    ///   - shadowRadius: The shadow radius to use for the specified state.
    ///   - state: The state that uses the specified shadow radius. The possible values are described in UIControlState.
    public func setShadowRadius(_ shadowRadius: CGFloat?, for state: UIControlState) {
        if shadowRadiusForState[state.rawValue] <-? shadowRadius { refreshBorderStyles() }
    }
    
    /// Set the shadow path to use for the specified state. `clipsToBounds` should be `false` to see the effect.
    ///
    /// - Parameters:
    ///   - shadowPath: The shadow path to use for the specified state.
    ///   - state: The state that uses the specified shadow path. The possible values are described in UIControlState.
    public func setShadowPath(_ shadowPath: CGPath?, for state: UIControlState) {
        if shadowPathForState[state.rawValue] <-? shadowPath { refreshBorderStyles() }
    }
    
    // MARK: - Getting Extra Presentation Styles
    
    /// Returns the background color associated with the specified state.
    ///
    /// - Parameter state: The state that uses the background color. The possible values are described in UIControlState.
    /// - Returns: The background color for the specified state. If no background color has been set for the specific state, this method returns the background color associated with the UIControlStateNormal state. If no background color has been set for the UIControlStateNormal state, nil is returned.
    public func backgroundColorForState(_ state: UIControlState) -> UIColor? {
        return _backgroundColorForState[state.rawValue] ?? _backgroundColorForState[UIControlState.normal.rawValue]
    }
    
    /**
     Returns the background image color associated with the specified state.
     
     - parameter state: The state that uses the background image color. The possible values are described in UIControlState.
     
     - returns: The background image color for the specified state. If no background image color has been set for the specific state, this method returns the background image color associated with the UIControlStateNormal state. If no background image color has been set for the UIControlStateNormal state, nil is returned.
     */
    public func backgroundImageColorForState(_ state: UIControlState) -> UIColor? {
        return backgroundImageColorForState[state.rawValue] ?? backgroundImageColorForState[UIControlState.normal.rawValue]
    }
    
    /// Returns the transform associated with the specified state.
    ///
    /// - Parameter state: The state that uses the transform. The possible values are described in UIControlState.
    /// - Returns: The transform for the specified state. If no transform has been set for the specific state, this method returns the transform associated with the UIControlStateNormal state. If no transform has been set for the UIControlStateNormal state, nil is returned.
    public func transformForState(_ state: UIControlState) -> CGAffineTransform? {
        return transformForState[state.rawValue] ?? transformForState[UIControlState.normal.rawValue]
    }
    
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
    
    /// Returns the shadow color used for a state.
    ///
    /// - Parameter state: The state that uses the shadow color. The possible values are described in UIControlState.
    /// - Returns: The shadow color for the specified state. If there's no shadow color is set for the state, shadow color for normal state is returned, otherwise, nil is returned.
    public func shadowColorForState(_ state: UIControlState) -> UIColor? {
        return shadowColorForState[state.rawValue] ?? shadowColorForState[UIControlState.normal.rawValue]
    }
    
    /// Returns the shadow opacity used for a state.
    ///
    /// - Parameter state: The state that uses the shadow opacity. The possible values are described in UIControlState.
    /// - Returns: The shadow opacity for the specified state. If there's no shadow opacity is set for the state, shadow opacity for normal state is returned, otherwise, nil is returned.
    public func shadowOpacityForState(_ state: UIControlState) -> Float? {
        return shadowOpacityForState[state.rawValue] ?? shadowOpacityForState[UIControlState.normal.rawValue]
    }
    
    /// Returns the shadow offset used for a state.
    ///
    /// - Parameter state: The state that uses the shadow offset. The possible values are described in UIControlState.
    /// - Returns: The shadow offset for the specified state. If there's no shadow offset is set for the state, shadow offset for normal state is returned, otherwise, nil is returned.
    public func shadowOffsetForState(_ state: UIControlState) -> CGSize? {
        return shadowOffsetForState[state.rawValue] ?? shadowOffsetForState[UIControlState.normal.rawValue]
    }
    
    /// Returns the shadow radius used for a state.
    ///
    /// - Parameter state: The state that uses the shadow radius. The possible values are described in UIControlState.
    /// - Returns: The shadow radius for the specified state. If there's no shadow radius is set for the state, shadow radius for normal state is returned, otherwise, nil is returned.
    public func shadowRadiusForState(_ state: UIControlState) -> CGFloat? {
        return shadowRadiusForState[state.rawValue] ?? shadowRadiusForState[UIControlState.normal.rawValue]
    }
    
    /// Returns the shadow path used for a state.
    ///
    /// - Parameter state: The state that uses the shadow path. The possible values are described in UIControlState.
    /// - Returns: The shadow path for the specified state. If there's no shadow path is set for the state, shadow path for normal state is returned, otherwise, nil is returned.
    public func shadowPathForState(_ state: UIControlState) -> CGPath? {
        return shadowPathForState[state.rawValue] ?? shadowPathForState[UIControlState.normal.rawValue]
    }
}

// MARK: - Getting the Current State
extension Button {
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
    private var normalBackgroundColor: UIColor? { return _backgroundColorForState[UIControlState.normal.rawValue] }
    private var highlightedBackgroundColor: UIColor? { return _backgroundColorForState[UIControlState.highlighted.rawValue] }
    private var disabledBackgroundColor: UIColor? { return _backgroundColorForState[UIControlState.disabled.rawValue] }
    private var selectedBackgroundColor: UIColor? { return _backgroundColorForState[UIControlState.selected.rawValue] }
    
    private var normalTransform: CGAffineTransform? { return transformForState[UIControlState.normal.rawValue] }
    private var highlightedTransform: CGAffineTransform? { return transformForState[UIControlState.highlighted.rawValue] }
    private var disabledTransform: CGAffineTransform? { return transformForState[UIControlState.disabled.rawValue] }
    private var selectedTransform: CGAffineTransform? { return transformForState[UIControlState.selected.rawValue] }
    
    private var normalBorderColor: UIColor? { return borderColorForState[UIControlState.normal.rawValue] }
    private var highlightedBorderColor: UIColor? { return borderColorForState[UIControlState.highlighted.rawValue] }
    private var disabledBorderColor: UIColor? { return borderColorForState[UIControlState.disabled.rawValue] }
    private var selectedBorderColor: UIColor? { return borderColorForState[UIControlState.selected.rawValue] }
    
    private var normalBorderWidth: CGFloat? { return borderWidthForState[UIControlState.normal.rawValue] }
    private var highlightedBorderWidth: CGFloat? { return borderWidthForState[UIControlState.highlighted.rawValue] }
    private var disabledBorderWidth: CGFloat? { return borderWidthForState[UIControlState.disabled.rawValue] }
    private var selectedBorderWidth: CGFloat? { return borderWidthForState[UIControlState.selected.rawValue] }
    
    private var normalCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.normal.rawValue]?.value(for: self) }
    private var highlightedCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.highlighted.rawValue]?.value(for: self) }
    private var disabledCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.disabled.rawValue]?.value(for: self) }
    private var selectedCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.selected.rawValue]?.value(for: self) }
    
    private var normalShadowColor: UIColor? { return shadowColorForState[UIControlState.normal.rawValue] }
    private var highlightedShadowColor: UIColor? { return shadowColorForState[UIControlState.highlighted.rawValue] }
    private var disabledShadowColor: UIColor? { return shadowColorForState[UIControlState.disabled.rawValue] }
    private var selectedShadowColor: UIColor? { return shadowColorForState[UIControlState.selected.rawValue] }
    
    private var normalShadowOpacity: Float? { return shadowOpacityForState[UIControlState.normal.rawValue] }
    private var highlightedShadowOpacity: Float? { return shadowOpacityForState[UIControlState.highlighted.rawValue] }
    private var disabledShadowOpacity: Float? { return shadowOpacityForState[UIControlState.disabled.rawValue] }
    private var selectedShadowOpacity: Float? { return shadowOpacityForState[UIControlState.selected.rawValue] }
    
    private var normalShadowOffset: CGSize? { return shadowOffsetForState[UIControlState.normal.rawValue] }
    private var highlightedShadowOffset: CGSize? { return shadowOffsetForState[UIControlState.highlighted.rawValue] }
    private var disabledShadowOffset: CGSize? { return shadowOffsetForState[UIControlState.disabled.rawValue] }
    private var selectedShadowOffset: CGSize? { return shadowOffsetForState[UIControlState.selected.rawValue] }
    
    private var normalShadowRadius: CGFloat? { return shadowRadiusForState[UIControlState.normal.rawValue] }
    private var highlightedShadowRadius: CGFloat? { return shadowRadiusForState[UIControlState.highlighted.rawValue] }
    private var disabledShadowRadius: CGFloat? { return shadowRadiusForState[UIControlState.disabled.rawValue] }
    private var selectedShadowRadius: CGFloat? { return shadowRadiusForState[UIControlState.selected.rawValue] }
    
    private var normalShadowPath: CGPath? { return shadowPathForState[UIControlState.normal.rawValue] }
    private var highlightedShadowPath: CGPath? { return shadowPathForState[UIControlState.highlighted.rawValue] }
    private var disabledShadowPath: CGPath? { return shadowPathForState[UIControlState.disabled.rawValue] }
    private var selectedShadowPath: CGPath? { return shadowPathForState[UIControlState.selected.rawValue] }
    
    /**
     Refresh customized styles
     */
    fileprivate func refreshBorderStyles() {
        // add a fade transition.
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.075
        
        defer {
            if isAnimated {
                layer.add(transition, forKey: kCATransition)
            }
        }
        
        if state == .highlighted {
            backgroundColor =? highlightedBackgroundColor ?? normalBackgroundColor
            transform =? highlightedTransform ?? normalTransform
            layer.borderColor =? highlightedBorderColor?.cgColor ?? normalBorderColor?.cgColor
            layer.borderWidth =? highlightedBorderWidth ?? normalBorderWidth
            layer.cornerRadius =? highlightedCornerRadius ?? normalCornerRadius
            layer.shadowColor =? highlightedShadowColor?.cgColor ?? normalShadowColor?.cgColor
            layer.shadowOpacity =? highlightedShadowOpacity ?? normalShadowOpacity
            layer.shadowOffset =? highlightedShadowOffset ?? normalShadowOffset
            layer.shadowRadius =? highlightedShadowRadius ?? normalShadowRadius
            layer.shadowPath =? highlightedShadowPath ?? normalShadowPath
            
        } else if state == .disabled {
            backgroundColor =? disabledBackgroundColor ?? normalBackgroundColor
            transform =? disabledTransform ?? normalTransform
            layer.borderColor =? disabledBorderColor?.cgColor ?? normalBorderColor?.cgColor
            layer.borderWidth =? disabledBorderWidth ?? normalBorderWidth
            layer.cornerRadius =? disabledCornerRadius ?? normalCornerRadius
            layer.shadowColor = disabledShadowColor?.cgColor ?? normalShadowColor?.cgColor
            layer.shadowOpacity =? disabledShadowOpacity ?? normalShadowOpacity
            layer.shadowOffset =? disabledShadowOffset ?? normalShadowOffset
            layer.shadowRadius =? disabledShadowRadius ?? normalShadowRadius
            layer.shadowPath =? disabledShadowPath ?? normalShadowPath
            
        } else if state == .selected {
            backgroundColor =? selectedBackgroundColor ?? normalBackgroundColor
            transform =? selectedTransform ?? normalTransform
            layer.borderColor =? selectedBorderColor?.cgColor ?? normalBorderColor?.cgColor
            layer.borderWidth =? selectedBorderWidth ?? normalBorderWidth
            layer.cornerRadius =? selectedCornerRadius ?? normalCornerRadius
            layer.shadowColor = selectedShadowColor?.cgColor ?? normalShadowColor?.cgColor
            layer.shadowOpacity =? selectedShadowOpacity ?? normalShadowOpacity
            layer.shadowOffset =? selectedShadowOffset ?? normalShadowOffset
            layer.shadowRadius =? selectedShadowRadius ?? normalShadowRadius
            layer.shadowPath =? selectedShadowPath ?? normalShadowPath

        } else {
            // prolong the fade transition, this mimics UIButtonType.System behaviors
            transition.duration = 0.25
            
            // Defaults to .normal state
            backgroundColor =? normalBackgroundColor
            transform =? normalTransform
            layer.borderColor =? normalBorderColor?.cgColor
            layer.borderWidth =? normalBorderWidth
            layer.cornerRadius =? normalCornerRadius
            layer.shadowColor =? normalShadowColor?.cgColor
            layer.shadowOpacity =? normalShadowOpacity
            layer.shadowOffset =? normalShadowOffset
            layer.shadowRadius =? normalShadowRadius
            layer.shadowPath =? normalShadowPath
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
