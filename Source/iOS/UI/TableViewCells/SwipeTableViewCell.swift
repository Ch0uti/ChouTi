//
//  SwipeTableViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-04.
//  Copyright © 2016 theScore Inc. All rights reserved.
//

import UIKit

/**
 SwipeTableVewCell Delegate.
 Delegate methods allow the delegate to react to cell swipe offset changes.
 */
public protocol SwipeTableViewCellDelegate: class {
    /**
     SwipeTableViewCell swiped to new offset.
     
     - parameter cell:      SwipeTableViewCell self.
     - parameter newOffset: New offset swiped. Negative value means right side expanded.
     */
    func swipeTableViewCell(cell: SwipeTableViewCell, didSwipeToOffset newOffset: CGFloat)

    /**
     SwipeTableViewCell will expand on a side.
     
     - parameter cell:          SwipeTableViewCell self.
     - parameter didExpandSide: Side to expand.
     */
    func swipeTableViewCell(cell: SwipeTableViewCell, willExpandSide: SwipeTableViewCell.ExpandSide)
    
    /**
     SwipeTableViewCell will collapse.
     
     - parameter cell: SwipeTableViewCell self.
     */
    func swipeTableViewCellWillCollapse(cell: SwipeTableViewCell)
}

/**
 UITableViewCell with swipe actions
 This is a cell which can swipe to show accessory view. Just like UIKit swipe to delete view.
 You need to configue `rightSwipeAccessoryView` to a view with constraint based layout (Require size constrained).
 */
public class SwipeTableViewCell: UITableViewCell {
    
    public enum ExpandSide {
        case Left
        case Right
    }

    // Swipeable content view, normally you should add subviews on this view
    public final let swipeableContentView = UIView()
    
    // MARK: - Right Accessory View
    /// Accessory view to show when swipe from right to left ( <--o )
    /// Note: This view requires constraint based layout. Make sure this view has size constrained.
    public var rightSwipeAccessoryView: UIView? {
        didSet {
            guard let rightSwipeAccessoryView = rightSwipeAccessoryView else { return }
            rightSwipeAccessoryView.translatesAutoresizingMaskIntoConstraints = false
            contentView.insertSubview(rightSwipeAccessoryView, belowSubview: swipeableContentView)
            
            NSLayoutConstraint(item: rightSwipeAccessoryView, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
            NSLayoutConstraint(item: rightSwipeAccessoryView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0).active = true
        }
    }
    
    /// Checking whether cell is expanded on the right.
    public final var rightSwipeExpanded: Bool {
        // If cell is visible, check current swipeableContentView frame
        if let presentationLayer = swipeableContentView.layer.presentationLayer() as? CALayer {
            return presentationLayer.convertRect(presentationLayer.bounds, toLayer: contentView.layer).origin.x < 0.0
        }
        
        if swipeableContentViewCenterXConstraint.constant < 0.0 {
            // final state is right expanded
            return true
        }
        else if swipeableContentViewCenterXConstraint.constant > 0.0 {
            // final state is left expanded, not supported yet
            print("Error: left expanding is not supported yet")
            return false
        }
        else if swipeableContentViewCenterXConstraint.constant == 0 {
            // final state is collapsed
            if isAnimating == false {
                // and is not animating
                return false
            } else {
                // is animating, which means currently is still expanded
                return true
            }
        }
        
        return false
    }

    /// Expandable width for swiping on right
    private final var rightSwipeExpandableWidth: CGFloat { get { return rightSwipeAccessoryView?.bounds.width ?? 0.0 } }
    private final var rightSwipeEnabled: Bool { return rightSwipeExpandableWidth > 0.0 }
    
    // MARK: - Delegate
    /// Swipe table view cell delegate.
    public weak var swipeTableViewCellDelegate: SwipeTableViewCellDelegate?
    
    // MARK: - Private
    private final var swipeableContentViewCenterXConstraint: NSLayoutConstraint!
    private final var panStartPoint: CGPoint = .zero
    private final var centerXConstraintStartConstant: CGFloat = 0.0
    private final var isAnimating: Bool = false // whether cell expand/collapse is being animated

    // MARK: - Gesture Recognizers
    private final lazy var panRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeTableViewCell.panSwipeableContentView(_:)))
    private final let tapRecognizer = UITapGestureRecognizer()
    // This is a so called immediate touch gesture recognizer (no delay, triggers faster than tap gesture recognizer). Set `minimumPressDuration = 0`.
    // This gesture recognizer will be added on tableView. If cell is expanded, touch anywhere on tableView can collapse it. (mimics UIKIt behavior)
    private final let tableViewImmediateTouchRecognizer = UILongPressGestureRecognizer()
    
    // MARK: - Settings when cell's tableView is embedded in a scrollView
    /// Unscrollable screen edge width. Default value is 40
    /// Pans on this width of screen edges won't expand cell
    public final var unscrollableScreenEdgeWidth: CGFloat = 40
    
    /// Horizontal velocity threshold when scrolls cell, if scrolling velocity is greater than this threshold, cell won't expand.
    /// Default value is 750.0
    public final var cellScrollsVelocityThreshold: CGFloat = 750.0
    
    /// If this value is true, when a cell is expanded, touching on tableView collapses the cell first.
    /// If this value is false (default), when a cell is expanded, you can scroll the tableView or swipe on other cells. The expanded cell collapses automatically.
    public final var blockingTableViewWhenExpanded: Bool = false
    
    // MARK: - Methods
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private final func commonInit() {
        // Remove default selection style (long press on cell can select it)
        selectionStyle = .None
        
        swipeableContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(swipeableContentView)
        swipeableContentView.backgroundColor = UIColor.whiteColor()
        
        // Gestures
        // Pan on cells
        swipeableContentView.addGestureRecognizer(panRecognizer)
        panRecognizer.delegate = self
        
        // Tap on cells
        contentView.addGestureRecognizer(tapRecognizer)
        tapRecognizer.delegate = self
        
        // Touch on tableView, will be added in `didMoveToSuperview`
        tableViewImmediateTouchRecognizer.minimumPressDuration = 0.0
        tableViewImmediateTouchRecognizer.delegate = self
        
        // Setup gesture dependency
        panRecognizer.setToDependOn(tableViewImmediateTouchRecognizer)
        tapRecognizer.setToDependOn(tableViewImmediateTouchRecognizer)
        
        setupConstraints()
    }
    
    private final func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        // Swipeable content view
        swipeableContentViewCenterXConstraint = NSLayoutConstraint(item: swipeableContentView,
                                                                   attribute: .CenterX,
                                                                   relatedBy: .Equal,
                                                                   toItem: contentView,
                                                                   attribute: .CenterX,
                                                                   multiplier: 1.0,
                                                                   constant: 0.0)
        
        constraints += [
            NSLayoutConstraint(item: swipeableContentView, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: swipeableContentView, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Width, multiplier: 1.0, constant: 0.0),
            swipeableContentViewCenterXConstraint,
            NSLayoutConstraint(item: swipeableContentView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        ]
        
        // This resolves `UITableViewCellContentView`'s NSAutoresizingMaskLayoutConstraint or `UIView-Encapsulated-Layout-Height` warnings when setting `contentView` height using constraints.
        // http://stackoverflow.com/a/38086932/3164091
        contentView.autoresizingMask = [.FlexibleHeight]
        
        // set 44.0 default cell height
        let cellHeightConstraint = NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 44.0)
        cellHeightConstraint.priority = 250
        constraints += [cellHeightConstraint]
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
}

// MARK: - Expanding/Collapse
extension SwipeTableViewCell {
    /**
     Expand right side to show right accessory view.
     
     - parameter animated: Whether it's should be animated.
     */
    public func expandRightSide(animated animated: Bool) {
        // If can expand right side, tell delegate
        if swipeableContentViewCenterXConstraint.constant != -rightSwipeExpandableWidth {
            swipeTableViewCellDelegate?.swipeTableViewCell(self, willExpandSide: .Right)
        }

        setExpandOffset(rightSwipeExpandableWidth, animated: animated)
    }
    
    /**
     Collapse self.
     
     - parameter animated: Whether it's should be animated.
     */
    public func collapse(animated animated: Bool) {
        // If can collapse, tell delegate
        if swipeableContentViewCenterXConstraint.constant != 0 {
            swipeTableViewCellDelegate?.swipeTableViewCellWillCollapse(self)
        }

        setExpandOffset(0, animated: animated)
    }
    
    /**
     Update swipeable content view with expand offset. (Offset is positive if expand on right side)
     
     - parameter offset:   New offset to set.
     - parameter animated: Whether it's should be animated.
     */
    private final func setExpandOffset(offset: CGFloat, animated: Bool) {
        // Avoid duplicated calls, avoid unnecessary `layoutIfNeeded` calls
        guard swipeableContentViewCenterXConstraint.constant != -offset else { return }

        swipeableContentViewCenterXConstraint.constant = -offset
        swipeTableViewCellDelegate?.swipeTableViewCell(self, didSwipeToOffset: -offset)
        
        if animated {
            isAnimating = true
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.CurveEaseInOut, .BeginFromCurrentState, .AllowUserInteraction], animations: {
                self.swipeableContentView.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.isAnimating = false
            })
        } else {
            swipeableContentView.superview?.layoutIfNeeded()
        }
    }
}

// MARK: - Gesture Recognizer Actions
extension SwipeTableViewCell {
    private dynamic func panSwipeableContentView(panRecognizer: UIPanGestureRecognizer) {
        let currentPoint = panRecognizer.translationInView(swipeableContentView)
        let deltaX = { currentPoint.x - panStartPoint.x }()
        
        switch panRecognizer.state {
        case .Began:
            panStartPoint = currentPoint
            centerXConstraintStartConstant = swipeableContentViewCenterXConstraint.constant
            
        case .Changed:
            let newConstant = centerXConstraintStartConstant + deltaX
            // Disable swipe cell to right
            if newConstant > 0 {
                setExpandOffset(0.0, animated: false)
            }
            else if -newConstant < rightSwipeExpandableWidth {
                // When swipe offset within swipExandable width, linear function
                // This makes cell move along with finger
                setExpandOffset(-newConstant, animated: false)
            }
            else {
                // When swipe offset exceeds swipeExpandable width, logarithm function
                // This makes cell moves with a hysteresis affect. (Make users feel they cannot move it furthermore)
                
                // Delta of X offset that exceeds swipeExpandable width
                let logDeltaX = max(-newConstant - rightSwipeExpandableWidth, 0)
                
                // New constant is composed with linear value + logarithm value (reduced value)
                setExpandOffset(rightSwipeExpandableWidth + (logDeltaX + log(1.0 + logDeltaX)) / 3.0, animated: false)
            }
            
        case .Ended, .Cancelled:
            let velocity = panRecognizer.velocityInView(contentView)
            // If swipe velocity is fast enough, expand cell without checking the width expanded.
            if velocity.x < -800 {
                expandRightSide(animated: true)
            }
            else {
                // If swipe slowly, check the width already expanded to determine whether expand or collapse.
                if -deltaX / rightSwipeExpandableWidth > 0.5 {
                    expandRightSide(animated: true)
                }
                else {
                    collapse(animated: true)
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension SwipeTableViewCell {
    public override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if rightSwipeEnabled == false {
            return false
        }
        
        if gestureRecognizer === tableViewImmediateTouchRecognizer {
            // Touches on tableView should collapse cells
            // Only needs to collapse when cell is expanded
            if rightSwipeExpanded == true {
                let locationInContentView = tableViewImmediateTouchRecognizer.locationInView(contentView)
                
                // Touches on the cell
                if contentView.bounds.contains(locationInContentView) {
                    let swipeableContentViewFrameInContentView = swipeableContentView.convertRect(swipeableContentView.bounds, toView: contentView)
                    let touchedOnSwipeableContentView = swipeableContentViewFrameInContentView.contains(locationInContentView)
                    // Touches on swipeable area should collapse
                    if touchedOnSwipeableContentView {
                        collapse(animated: true)
                        return blockingTableViewWhenExpanded
                    }
                    else {
                        // Touches on accessory area, ignore.
                        return false
                    }
                }
                else {
                    // Touches on outside of the cell, should collapse
                    collapse(animated: true)
                    return blockingTableViewWhenExpanded
                }
            }
            else {
                // Touches when cell is in normal state, ignore
                return false
            }
        }
        
        if gestureRecognizer === tapRecognizer && isAnimating == false {
            // If is expanded, consume this touch, which disables selection of tableViewCell
            return rightSwipeExpanded
        }
        
        if gestureRecognizer === panRecognizer {
            // Ref: http://stackoverflow.com/a/8603839/3164091
            let velocity = panRecognizer.velocityInView(nil)
            
            // Ignore touches if pans vertically
            if fabs(velocity.y) > fabs(velocity.x) {
                return false
            }
            
            // Expanded State: immediate touch gesture will collapse it, ignore pan gesture.
            if rightSwipeExpanded == true {
                return false
            }
            
            // Normal State
            guard isEmbeddedInScrollView() else { return true }
            guard let window = window else { return false }
            
            // Ignore screen edge pans
            let locationInWindow = panRecognizer.locationInView(window)
            // Ref: http://stackoverflow.com/a/14105964/3164091
            let locationInScreen = window.convertPoint(locationInWindow, toWindow: nil)
            let screenBounds = window.convertRect(window.bounds, toWindow: nil)
            
            // Pans on screen edges, should not expand cell.
            if locationInScreen.x < unscrollableScreenEdgeWidth || locationInScreen.x > screenBounds.width - unscrollableScreenEdgeWidth {
                return false
            }
            
            // Handle cases if tableView is on a scrollView. This usually the case there's a super page view controller.
            // Swipe: <--o
            if velocity.x < 0 {
                // Only handle pan if swipe slowly
                return abs(velocity.x) < cellScrollsVelocityThreshold
            }
            else {
                // Swipe: o-->
                return false
            }
        }
        
        return true
    }
}

// MARK: - Automatic collapsing
extension SwipeTableViewCell {
    public override func prepareForReuse() {
        super.prepareForReuse()
        collapse(animated: true)
    }
    
    public override func willTransitionToState(state: UITableViewCellStateMask) {
        super.willTransitionToState(state)
        // Any cell state transition should collapse
        collapse(animated: true)
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        collapse(animated: true)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // Setup tableViewImmediateTouchRecognizer to new tableView
        guard let tableView = tableView else { return }
        tableView.addGestureRecognizer(tableViewImmediateTouchRecognizer)
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        // Remove tableViewImmediateTouchRecognizer from current tableView
        guard let tableView = tableView else { return }
        tableView.removeGestureRecognizer(tableViewImmediateTouchRecognizer)
    }
}

// MARK: - Private Helpers
extension SwipeTableViewCell {
    /**
     Whether the tableView managing this cell is embedded in a scrollView
     
     - returns: true if there's a such scrollView. Otherwise, false.
     */
    private final func isEmbeddedInScrollView() -> Bool {
        return tableView?.superviewOfType(UIScrollView) != nil
    }
}
