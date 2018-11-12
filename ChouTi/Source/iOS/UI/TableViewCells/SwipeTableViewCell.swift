//
//  Created by Honghao Zhang on 08/04/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

/**
 SwipeTableVewCell Delegate.
 Delegate methods allow the delegate to react to cell swipe offset changes.
 */
public protocol SwipeTableViewCellDelegate: AnyObject {
    /**
     SwipeTableViewCell swiped to new offset.
     
     - parameter cell:      SwipeTableViewCell self.
     - parameter newOffset: New offset swiped. Negative value means right side expanded.
     */
    func swipeTableViewCell(_ cell: SwipeTableViewCell, didSwipeToOffset newOffset: CGFloat)

    /**
     SwipeTableViewCell will expand on a side.
     
     - parameter cell:          SwipeTableViewCell self.
     - parameter didExpandSide: Side to expand.
     */
    func swipeTableViewCell(_ cell: SwipeTableViewCell, willExpandSide: SwipeTableViewCell.ExpandSide)

    /**
     SwipeTableViewCell will collapse.
     
     - parameter cell: SwipeTableViewCell self.
     */
    func swipeTableViewCellWillCollapse(_ cell: SwipeTableViewCell)
}

/// UITableViewCell with swipe actions
/// This is a cell which can swipe to show accessory view. Just like UIKit swipe to delete view.
/// You need to configue `rightSwipeAccessoryView` to a view with constraint based layout (Require size constrained).
open class SwipeTableViewCell: UITableViewCell {

    public enum ExpandSide {
        case left
        case right
    }

	/// Swipeable content view, normally you should add subviews on this view.
	/// Discussion: This view is above the `contentView`, so when you swipe the cell, this view moves.
	///   You should add moveable content on this view and fixed content (like action buttons) on `contentView`
	public final let swipeableContentView: UIView = {
		/// A View that you can not set to transparent
		/// Discussion: Because UITableViewCell make all subViews transparent when it's highlighted/selected. This
		/// ContentView should not be set to transparent, otherwises, the accessory view behind it appears.
		/// Check `setSelected(Bool, animated: Bool)` and `func setHighlighted(Bool, animated: Bool)` implementations
		/// Reference: http://stackoverflow.com/a/15342964/3164091
		final class NoTransparentView: UIView {
			override var backgroundColor: UIColor? {
				set {
					guard let newValue = newValue else {
						return
					}

					if newValue.cgColor.alpha == 0 {
						return
					}

					super.backgroundColor = newValue
				}

				get {
					return super.backgroundColor
				}
			}
		}
		return NoTransparentView()
	}()

    // MARK: - Right Accessory View
    /// Accessory view to show when swipe from right to left ( <--o )
    /// Note: This view requires constraint based layout. Make sure this view has size constrained.
    open var rightSwipeAccessoryView: UIView? {
        didSet {
            guard let rightSwipeAccessoryView = rightSwipeAccessoryView else {
                return
            }
            rightSwipeAccessoryView.translatesAutoresizingMaskIntoConstraints = false
            contentView.insertSubview(rightSwipeAccessoryView, belowSubview: swipeableContentView)

            NSLayoutConstraint(item: rightSwipeAccessoryView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: rightSwipeAccessoryView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        }
    }

    /// Checking whether cell is expanded on the right.
    public final var rightSwipeExpanded: Bool {
        // If cell is visible, check current swipeableContentView frame
        if let presentationLayer = swipeableContentView.layer.presentation() {
            return presentationLayer.convert(presentationLayer.bounds, to: contentView.layer).origin.x < 0.0
        }

        if swipeableContentViewCenterXConstraint.constant < 0.0 {
            // Final state is right expanded
            return true
        } else if swipeableContentViewCenterXConstraint.constant > 0.0 {
            // Final state is left expanded, not supported yet
            print("Error: left expanding is not supported yet")
            return false
        } else if swipeableContentViewCenterXConstraint.constant == 0 {
            // Final state is collapsed
            if isAnimating == false {
                // And is not animating
                return false
            } else {
                // Is animating, which means currently is still expanded
                return true
            }
        }

        return false
    }

    /// Expandable width for swiping on right
    private final var rightSwipeExpandableWidth: CGFloat { return rightSwipeAccessoryView?.bounds.width ?? 0.0 }
    private final var rightSwipeEnabled: Bool { return rightSwipeExpandableWidth > 0.0 }

    // MARK: - Delegate
    /// Swipe table view cell delegate.
    open weak var swipeTableViewCellDelegate: SwipeTableViewCellDelegate?

    // MARK: - Private
    private final var swipeableContentViewCenterXConstraint: NSLayoutConstraint!
    private final var panStartPoint: CGPoint = .zero
    private final var centerXConstraintStartConstant: CGFloat = 0.0
    private final var isAnimating: Bool = false // whether cell expand/collapse is being animated

    // MARK: - Gesture Recognizers
    private final lazy var panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeTableViewCell.panSwipeableContentView(_:)))
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
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private final func commonInit() {
        swipeableContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(swipeableContentView)
        swipeableContentView.backgroundColor = UIColor.white

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
                                                                   attribute: .centerX,
                                                                   relatedBy: .equal,
                                                                   toItem: contentView,
                                                                   attribute: .centerX,
                                                                   multiplier: 1.0,
                                                                   constant: 0.0)

        constraints += [
			swipeableContentView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
			swipeableContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
			swipeableContentViewCenterXConstraint!,
			swipeableContentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]

        // This resolves `UITableViewCellContentView`'s NSAutoresizingMaskLayoutConstraint or `UIView-Encapsulated-Layout-Height` warnings when setting `contentView` height using constraints.
        // Ref: http://stackoverflow.com/a/38086932/3164091
        contentView.autoresizingMask = [.flexibleHeight]

        // Set 44.0 default cell height
        let cellHeightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 44.0)
        cellHeightConstraint.priority = UILayoutPriority(250)
        constraints += [cellHeightConstraint]

        NSLayoutConstraint.activate(constraints)
    }

	override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
		if let selectedBackgroundView = selectedBackgroundView {
			if highlighted {
				swipeableContentView.insertSubview(selectedBackgroundView, at: 0)
			} else {
				selectedBackgroundView.removeFromSuperview()
			}
		}
	}

	override open func setSelected(_ selected: Bool, animated: Bool) {
		if let selectedBackgroundView = selectedBackgroundView {
			if selected {
				swipeableContentView.insertSubview(selectedBackgroundView, at: 0)
			} else {
				selectedBackgroundView.removeFromSuperview()
			}
		}
	}
}

// MARK: - Expanding/Collapse
extension SwipeTableViewCell {
    /**
     Expand right side to show right accessory view.
     
     - parameter animated: Whether it's should be animated.
     */
    public func expandRightSide(animated: Bool) {
        // If can expand right side, tell delegate
        if swipeableContentViewCenterXConstraint.constant != -rightSwipeExpandableWidth {
            swipeTableViewCellDelegate?.swipeTableViewCell(self, willExpandSide: .right)
        }

        setExpandOffset(rightSwipeExpandableWidth, animated: animated)
    }

    /**
     Collapse self.
     
     - parameter animated: Whether it's should be animated.
     */
    public func collapse(animated: Bool) {
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
    private final func setExpandOffset(_ offset: CGFloat, animated: Bool) {
        // Avoid duplicated calls, avoid unnecessary `layoutIfNeeded` calls
        guard swipeableContentViewCenterXConstraint.constant != -offset else {
            return
        }

        swipeableContentViewCenterXConstraint.constant = -offset
        swipeTableViewCellDelegate?.swipeTableViewCell(self, didSwipeToOffset: -offset)

        if animated {
            isAnimating = true
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction], animations: {
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
    @objc
    private dynamic func panSwipeableContentView(_ panRecognizer: UIPanGestureRecognizer) {
        let currentPoint = panRecognizer.translation(in: swipeableContentView)
        let deltaX = { currentPoint.x - panStartPoint.x }()

        switch panRecognizer.state {
        case .began:
            panStartPoint = currentPoint
            centerXConstraintStartConstant = swipeableContentViewCenterXConstraint.constant

        case .changed:
            let newConstant = centerXConstraintStartConstant + deltaX
            // Disable swipe cell to right
            if newConstant > 0 {
                setExpandOffset(0.0, animated: false)
            } else if -newConstant < rightSwipeExpandableWidth {
                // When swipe offset within swipExandable width, linear function
                // This makes cell move along with finger
                setExpandOffset(-newConstant, animated: false)
            } else {
                // When swipe offset exceeds swipeExpandable width, logarithm function
                // This makes cell moves with a hysteresis affect. (Make users feel they cannot move it furthermore)

                // Delta of X offset that exceeds swipeExpandable width
                let logDeltaX = max(-newConstant - rightSwipeExpandableWidth, 0)

                // New constant is composed with linear value + logarithm value (reduced value)
                setExpandOffset(rightSwipeExpandableWidth + (logDeltaX + log(1.0 + logDeltaX)) / 3.0, animated: false)
            }

        case .ended, .cancelled:
            let velocity = panRecognizer.velocity(in: contentView)
            // If swipe velocity is fast enough, expand cell without checking the width expanded.
            if velocity.x < -800 {
                expandRightSide(animated: true)
            } else {
                // If swipe slowly, check the width already expanded to determine whether expand or collapse.
                if -deltaX / rightSwipeExpandableWidth > 0.5 {
                    expandRightSide(animated: true)
                } else {
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
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if rightSwipeEnabled == false {
            return false
        }

        if gestureRecognizer === tableViewImmediateTouchRecognizer {
            // Touches on tableView should collapse cells
            // Only needs to collapse when cell is expanded
            if rightSwipeExpanded == true {
                let locationInContentView = tableViewImmediateTouchRecognizer.location(in: contentView)

                // Touches on the cell
                if contentView.bounds.contains(locationInContentView) {
                    let swipeableContentViewFrameInContentView = swipeableContentView.convert(swipeableContentView.bounds, to: contentView)
                    let touchedOnSwipeableContentView = swipeableContentViewFrameInContentView.contains(locationInContentView)
                    // Touches on swipeable area should collapse
                    if touchedOnSwipeableContentView {
                        collapse(animated: true)
                        return blockingTableViewWhenExpanded
                    } else {
                        // Touches on accessory area, ignore.
                        return false
                    }
                } else {
                    // Touches on outside of the cell, should collapse
                    collapse(animated: true)
                    return blockingTableViewWhenExpanded
                }
            } else {
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
            let velocity = panRecognizer.velocity(in: nil)

            // Ignore touches if pans vertically
            if abs(velocity.y) > abs(velocity.x) {
                return false
            }

            // Expanded State: immediate touch gesture will collapse it, ignore pan gesture.
            if rightSwipeExpanded == true {
                return false
            }

            // Normal State
            guard isEmbeddedInScrollView() else {
                return true
            }
            guard let window = window else {
                return false
            }

            // Ignore screen edge pans
            let locationInWindow = panRecognizer.location(in: window)
            // Ref: http://stackoverflow.com/a/14105964/3164091
            let locationInScreen = window.convert(locationInWindow, to: nil)
            let screenBounds = window.convert(window.bounds, to: nil)

            // Pans on screen edges, should not expand cell.
            if locationInScreen.x < unscrollableScreenEdgeWidth || locationInScreen.x > screenBounds.width - unscrollableScreenEdgeWidth {
                return false
            }

            // Handle cases if tableView is on a scrollView. This usually the case there's a super page view controller.
            // Swipe: <--o
            if velocity.x < 0 {
                // Only handle pan if swipe slowly
                return abs(velocity.x) < cellScrollsVelocityThreshold
            } else {
                // Swipe: o-->
                return false
            }
        }

        return true
    }
}

// MARK: - Automatic collapsing
extension SwipeTableViewCell {
    override open func prepareForReuse() {
        super.prepareForReuse()

        collapse(animated: true)
    }

    override open func willTransition(to state: UITableViewCell.StateMask) {
        super.willTransition(to: state)

        // Any cell state transition should collapse
        collapse(animated: true)
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()

        collapse(animated: true)
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()

        // Setup tableViewImmediateTouchRecognizer to new tableView
        guard let tableView = tableView else {
            return
        }
        tableView.addGestureRecognizer(tableViewImmediateTouchRecognizer)
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        // Remove tableViewImmediateTouchRecognizer from current tableView
        guard let tableView = tableView else {
            return
        }
        tableView.removeGestureRecognizer(tableViewImmediateTouchRecognizer)
    }
}

// MARK: - Private Helpers
private extension SwipeTableViewCell {
    /**
     Whether the tableView managing this cell is embedded in a scrollView
     
     - returns: true if there's a such scrollView. Otherwise, false.
     */
    final func isEmbeddedInScrollView() -> Bool {
		return tableView?.superview(ofType: UIScrollView.self) != nil
    }
}
