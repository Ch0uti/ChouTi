//
//  Button.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-05-06.
//
//

import UIKit

public class Button: UIButton {
    
    private lazy var borderColorForState: [UInt : UIColor] = { [:] }()
    private lazy var borderWidthForState: [UInt : CGFloat] = { [:] }()
    private lazy var cornerRadiusForState: [UInt : CGFloat] = { [:] }()
    private lazy var backgroundColorForState: [UInt : UIColor] = { [:] }()
    
    private var normalBorderColor: UIColor? { return borderColorForState[UIControlState.Normal.rawValue] }
    private var highlightedBorderColor: UIColor? { return borderColorForState[UIControlState.Highlighted.rawValue] }
    private var disabledBorderColor: UIColor? { return borderColorForState[UIControlState.Disabled.rawValue] }
    private var selectedBorderColor: UIColor? { return borderColorForState[UIControlState.Selected.rawValue] }
    
    private var normalBorderWidth: CGFloat? { return borderWidthForState[UIControlState.Normal.rawValue] }
    private var highlightedBorderWidth: CGFloat? { return borderWidthForState[UIControlState.Highlighted.rawValue] }
    private var disabledBorderWidth: CGFloat? { return borderWidthForState[UIControlState.Disabled.rawValue] }
    private var selectedBorderWidth: CGFloat? { return borderWidthForState[UIControlState.Selected.rawValue] }
    
    private var normalCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.Normal.rawValue] }
    private var highlightedCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.Highlighted.rawValue] }
    private var disabledCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.Disabled.rawValue] }
    private var selectedCornerRadius: CGFloat? { return cornerRadiusForState[UIControlState.Selected.rawValue] }
    
    /**
     Sets the border color to use for the specified state.
     
     - parameter color: The border color to use for the specified state.
     - parameter state: The state that uses the specified border color. The possible values are described in UIControlState.
     */
    public func setBorderColor(color: UIColor, forState state: UIControlState) {
        borderColorForState[state.rawValue] = color
        refreshStyles()
    }
    
    /**
     Sets the border width to use for the specified state.
     
     - parameter width: The border width to use for the specified state.
     - parameter state: The state that uses the specified border width. The possible values are described in UIControlState.
     */
    public func setBorderWidth(width: CGFloat, forState state: UIControlState) {
        borderWidthForState[state.rawValue] = width
        refreshStyles()
    }
    
    /**
     Sets the corner radius to use for the specified state.
     
     - parameter cornerRadius: The corner radius to use for the specified state.
     - parameter state:        The state that uses the specified corner radius. The possible values are described in UIControlState.
     */
    public func setCornerRadius(cornerRadius: CGFloat, forState state: UIControlState) {
        cornerRadiusForState[state.rawValue] = cornerRadius
        refreshStyles()
    }
    
    /**
     Sets the background color to use for the specified state.
     
     - parameter color: The background color to use for the specified state.
     - parameter state: The state that uses the specified background color. The possible values are described in UIControlState.
     */
    public override func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        super.setBackgroundColor(color, forState: state)
        
        backgroundColorForState[state.rawValue] = color
    }
    
    public override var highlighted: Bool { didSet { refreshStyles() } }
    public override var enabled: Bool { didSet { refreshStyles() } }
    public override var selected: Bool { didSet { refreshStyles() } }
    
    /// The current border color that is displayed on the button. (read-only)
    public var currentBorderColor: UIColor { return UIColor(CGColor: layer.borderColor ?? UIColor.blackColor().CGColor) }
    
    /// The current border width that is displayed on the button. (read-only)
    public var currentBorderWidth: CGFloat { return layer.borderWidth }
    
    /// The current corner radius that is displayed on the button. (read-only)
    public var currentCornerRadius: CGFloat { return layer.cornerRadius }
    
    /// The current background color that is displayed on the button. (read-only)
    public var currentBackgroundColor: UIColor? { return backgroundColorForState[state.rawValue] ?? backgroundColorForState[UIControlState.Normal.rawValue] }
    
    /**
     Returns the border color associated with the specified state.
     
     - parameter state: The state that uses the border color. The possible values are described in UIControlState.
     
     - returns: The border color for the specified state. If no border color has been set for the specific state, this method returns the border color associated with the UIControlStateNormal state. If no border color has been set for the UIControlStateNormal state, nil is returned.
     */
    public func borderColorForState(_ state: UIControlState) -> UIColor? {
        return borderColorForState[state.rawValue] ?? borderColorForState[UIControlState.Normal.rawValue] ?? nil
    }
    
    /**
     Returns the border width used for a state.
     
     - parameter state: The state that uses the border width. The possible values are described in UIControlState.
     
     - returns: The border width for the specified state. If there's no border width is set for the state, border width for normal state is returned, otherwise, default value 0.0 is returned.
     */
    public func borderWidthForState(_ state: UIControlState) -> CGFloat {
        return borderWidthForState[state.rawValue] ?? borderWidthForState[UIControlState.Normal.rawValue] ?? 0.0
    }
    
    /**
     Returns the corner radius used for a state.
     
     - parameter state: The state that uses the corner radius. The possible values are described in UIControlState.
     
     - returns: The corner radius for the specified state. If there's no corner radius is set for the state, corner radius for normal state is returned, otherwise, default value 0.0 is returned.
     */
    public func cornerRadiusForState(_ state: UIControlState) -> CGFloat {
        return cornerRadiusForState[state.rawValue] ?? cornerRadiusForState[UIControlState.Normal.rawValue] ?? 0.0
    }
    
    /**
     Returns the background color associated with the specified state.
     
     - parameter state: The state that uses the background color. The possible values are described in UIControlState.
     
     - returns: The background color for the specified state. If no background color has been set for the specific state, this method returns the background color associated with the UIControlStateNormal state. If no background color has been set for the UIControlStateNormal state, nil is returned.
     */
    public func backgroundColorForState(_ state: UIControlState) -> UIColor? {
        return backgroundColorForState[state.rawValue] ?? backgroundColorForState[UIControlState.Normal.rawValue] ?? nil
    }
}

// MARK: - Private Helpers
extension Button {
    /**
     Refresh customized styles, some styles are not easy to understand, truth table is comming from trials
     */
    private func refreshStyles() {
        switch (enabled, highlighted, selected) {
        case (true, true, true):
            applyStyleForState(.Normal) // When hightlighted and selected are both true, show normal appearance
            
        case (true, true, false):
            applyStyleForState(.Highlighted) // Straightforward
            
        case (true, false, true):
            applyStyleForState(.Selected) // Straightforward
            
        case (true, false, false):
            applyStyleForState(.Normal) // Straightforward
            
        case (false, true, true):
            applyStyleForState(.Normal) // When disabled and selected is true, show notmal appearance
            
        case (false, true, false):
            applyStyleForState(.Disabled) //
            
        case (false, false, true):
            applyStyleForState(.Normal) // When disabled and selected is true, show notmal appearance
            
        case (false, false, false):
            applyStyleForState(.Disabled) // Straightforward
        }
    }
    
    private func applyStyleForState(state: UIControlState) {
        let state = self.state
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
}
