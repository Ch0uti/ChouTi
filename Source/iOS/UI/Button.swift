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
public class Button: UIButton {
    
    /**
     Corner radius attribute, used in CornerRadius .Relative case
     
     - Width:  Width
     - Height: Height
     */
    public enum Attribute {
        case Width
        case Height
    }
    
    /**
     Corner radius option
     
     - Absolute:   absolute corner radius
     - Relative:   relative corner radius, calculated by percetage multiply by width or height
     - HalfCircle: half-circle, capsule like
     */
    public enum CornerRadius {
        case Absolute(CGFloat)
        case Relative(percent: CGFloat, attribute: Attribute)
        case HalfCircle
        
        func value(view: UIView) -> CGFloat {
            switch self {
            case .Absolute(let cornerRadius):
                return cornerRadius
                
            case .Relative(percent: let percent, attribute: let attribute):
                switch attribute {
                case .Width:
                    return percent * view.bounds.width
                case .Height:
                    return percent * view.bounds.height
                }
                
            case .HalfCircle:
                return 0.5 * min(view.bounds.width, view.bounds.height)
            }
        }
    }
    
    // MARK: - Storing Extra Presentation Styles
    private lazy var borderColorForState: [UInt : UIColor] = { [:] }()
    private lazy var borderWidthForState: [UInt : CGFloat] = { [:] }()
    private lazy var cornerRadiusForState: [UInt : CornerRadius] = { [:] }()
    private lazy var backgroundImageColorForState: [UInt : UIColor] = { [:] }()
    
    // MARK: - Overriden
    public override var highlighted: Bool { didSet { refreshBorderStyles() } }
    public override var enabled: Bool { didSet { refreshBorderStyles() } }
    public override var selected: Bool { didSet { refreshBorderStyles() } }
    
    public override func layoutSubviews() {
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
    public func setBorderColor(color: UIColor, forState state: UIControlState) {
        borderColorForState[state.rawValue] = color
        refreshBorderStyles()
    }
    
    /**
     Set the border width to use for the specified state.
     
     - parameter width: The border width to use for the specified state.
     - parameter state: The state that uses the specified border width. The possible values are described in UIControlState.
     */
    public func setBorderWidth(width: CGFloat, forState state: UIControlState) {
        borderWidthForState[state.rawValue] = width
        refreshBorderStyles()
    }
    
    /**
     Set the corner radius to use for the specified state.
     
     - parameter cornerRadius: The corner radius to use for the specified state.
     - parameter state:        The state that uses the specified corner radius. The possible values are described in UIControlState.
     */
    public func setCornerRadius(cornerRadius: CornerRadius, forState state: UIControlState) {
        clipsToBounds = true
        cornerRadiusForState[state.rawValue] = cornerRadius
        refreshBorderStyles()
    }
    
    /**
     Set the background image with color to use for the specified state.
     
     - parameter color: The color for background image to use for the specified state.
     - parameter state: The state that uses the specified background image color. The possible values are described in UIControlState.
     */
    public override func setBackgroundImageWithColor(color: UIColor, forState state: UIControlState) {
        setBackgroundImage(UIImage.imageWithColor(color), forState: state)
        backgroundImageColorForState[state.rawValue] = color
    }
    
    // MARK: - Getting Extra Presentation Styles
    
    /**
     Returns the border color associated with the specified state.
     
     - parameter state: The state that uses the border color. The possible values are described in UIControlState.
     
     - returns: The border color for the specified state. If no border color has been set for the specific state, this method returns the border color associated with the UIControlStateNormal state. If no border color has been set for the UIControlStateNormal state, nil is returned.
     */
    public func borderColorForState(state: UIControlState) -> UIColor? {
        return borderColorForState[state.rawValue] ?? borderColorForState[UIControlState.Normal.rawValue] ?? nil
    }
    
    /**
     Returns the border width used for a state.
     
     - parameter state: The state that uses the border width. The possible values are described in UIControlState.
     
     - returns: The border width for the specified state. If there's no border width is set for the state, border width for normal state is returned, otherwise, default value 0.0 is returned.
     */
    public func borderWidthForState(state: UIControlState) -> CGFloat {
        return borderWidthForState[state.rawValue] ?? borderWidthForState[UIControlState.Normal.rawValue] ?? 0.0
    }
    
    /**
     Returns the corner radius used for a state.
     
     - parameter state: The state that uses the corner radius. The possible values are described in UIControlState.
     
     - returns: The corner radius for the specified state. If there's no corner radius is set for the state, corner radius for normal state is returned, otherwise, default value CornerRadius.Absolute(0.0) is returned.
     */
    public func cornerRadiusForState(state: UIControlState) -> CornerRadius {
        return cornerRadiusForState[state.rawValue] ?? cornerRadiusForState[UIControlState.Normal.rawValue] ?? .Absolute(0.0)
    }
    
    /**
     Returns the background image color associated with the specified state.
     
     - parameter state: The state that uses the background image color. The possible values are described in UIControlState.
     
     - returns: The background image color for the specified state. If no background image color has been set for the specific state, this method returns the background image color associated with the UIControlStateNormal state. If no background image color has been set for the UIControlStateNormal state, nil is returned.
     */
    public func backgroundImageColorForState(state: UIControlState) -> UIColor? {
        return backgroundImageColorForState[state.rawValue] ?? backgroundImageColorForState[UIControlState.Normal.rawValue] ?? nil
    }
}

// MARK: - Getting the Current State
extension Button {
    /// The current border color that is displayed on the button. (read-only)
    public var currentBorderColor: UIColor { return UIColor(CGColor: layer.borderColor ?? UIColor.blackColor().CGColor) }
    
    /// The current border width that is displayed on the button. (read-only)
    public var currentBorderWidth: CGFloat { return layer.borderWidth }
    
    /// The current corner radius that is displayed on the button. (read-only)
    public var currentCornerRadius: CornerRadius {
        return cornerRadiusForState[state.rawValue] ?? cornerRadiusForState[UIControlState.Normal.rawValue] ?? .Absolute(layer.cornerRadius)
    }
    
    /// The current background image color that is displayed on the button. (read-only)
    public var currentBackgroundImageColor: UIColor? {
        return backgroundImageColorForState[state.rawValue] ?? backgroundImageColorForState[UIControlState.Normal.rawValue]
    }
}

// MARK: - Private Helpers
extension Button {
    
    // MARK: - Convenient Values
    private var normalBorderColor: UIColor? { return borderColorForState[UIControlState.Normal.rawValue] }
    private var highlightedBorderColor: UIColor? { return borderColorForState[UIControlState.Highlighted.rawValue] }
    private var disabledBorderColor: UIColor? { return borderColorForState[UIControlState.Disabled.rawValue] }
    private var selectedBorderColor: UIColor? { return borderColorForState[UIControlState.Selected.rawValue] }
    
    private var normalBorderWidth: CGFloat? { return borderWidthForState[UIControlState.Normal.rawValue] }
    private var highlightedBorderWidth: CGFloat? { return borderWidthForState[UIControlState.Highlighted.rawValue] }
    private var disabledBorderWidth: CGFloat? { return borderWidthForState[UIControlState.Disabled.rawValue] }
    private var selectedBorderWidth: CGFloat? { return borderWidthForState[UIControlState.Selected.rawValue] }
    
    private var normalCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.Normal.rawValue]?.value(self) }
    private var highlightedCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.Highlighted.rawValue]?.value(self) }
    private var disabledCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.Disabled.rawValue]?.value(self) }
    private var selectedCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.Selected.rawValue]?.value(self) }
    
    /**
     Refresh customized styles
     */
    private func refreshBorderStyles() {
        if state == .Highlighted {
            layer.borderColor = highlightedBorderColor?.CGColor ?? normalBorderColor?.CGColor
            layer.borderWidth = highlightedBorderWidth ?? normalBorderWidth ?? 0.0
            layer.cornerRadius = highlightedCornerRadius ?? normalCornerRadius ?? 0.0
        } else if state == .Disabled {
            layer.borderColor = disabledBorderColor?.CGColor ?? normalBorderColor?.CGColor
            layer.borderWidth = disabledBorderWidth ?? normalBorderWidth ?? 0.0
            layer.cornerRadius = disabledCornerRadius ?? normalCornerRadius ?? 0.0
        } else if state == .Selected {
            layer.borderColor = selectedBorderColor?.CGColor ?? normalBorderColor?.CGColor
            layer.borderWidth = selectedBorderWidth ?? normalBorderWidth ?? 0.0
            layer.cornerRadius = selectedCornerRadius ?? normalCornerRadius ?? 0.0
        } else {
            // Defaults to .Normal state
            layer.borderColor = normalBorderColor?.CGColor
            layer.borderWidth = normalBorderWidth ?? 0.0
            layer.cornerRadius = normalCornerRadius ?? 0.0
        }
    }
    
//    private func refreshClearTitleMask() {
////        titleLabel?.backgroundColor = UIColor.clearColor()
//        let text = titleLabel?.text
//        let font = titleLabel?.font
//        
//        let attributes = [NSFontAttributeName : titleLabel?.font]
//        let textSize = text.
//    }
}
