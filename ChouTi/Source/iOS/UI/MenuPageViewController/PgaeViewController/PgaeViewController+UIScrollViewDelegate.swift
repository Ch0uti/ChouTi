//
//  Created by Honghao Zhang on 11/06/2018.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import Foundation

extension PageViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Vertical scrolling is disabled

        let scrollOffset = scrollView.contentOffset.x - CGFloat(selectedIndex) * view.bounds.width
        let scrollOffsetPercent = scrollOffset / view.bounds.width
        delegate?.pageViewController(self, didScrollWithSelectedIndex: selectedIndex, offsetPercent: scrollOffsetPercent)

        if !isDragging {
            guard let willEndDraggingTargetContentOffsetX = willEndDraggingTargetContentOffsetX else {
                return
            }
            let willSelectedIndex = Int(willEndDraggingTargetContentOffsetX) / Int(view.bounds.width)
            let willSelectedViewController = viewControllerForIndex(willSelectedIndex)

            // If current appearing view controller is not will selected view controller, state is mismatched. End it's transition
            let appearingViewControllers = Set(loadedViewControllers.filter { $0.isAppearing == true })
            assert(appearingViewControllers.count <= 1)
            if let willAppearViewController = appearingViewControllers.first, willAppearViewController !== willSelectedViewController {
                willAppearViewController.zhh_endAppearanceTransition()
            }

            // If the view controller moving to appearance call is not called, call it
            if willSelectedViewController?.isAppearing == nil {
                willSelectedViewController?.zhh_beginAppearanceTransition(true, animated: true)
            }

            // If selected view controller disappearing call is not called, call it
            if _selectedViewController?.isAppearing == nil {
                _selectedViewController?.zhh_beginAppearanceTransition(false, animated: true)
            }

            return
        }

        // Dragging Zero offset
        guard let draggingForward = draggingForward else {
            if forwardViewController?.isAppearing != nil {
                forwardViewController?.zhh_beginAppearanceTransition(false, animated: false)
                forwardViewController?.zhh_endAppearanceTransition()
            }

            if backwardViewController?.isAppearing != nil {
                backwardViewController?.zhh_beginAppearanceTransition(false, animated: false)
                backwardViewController?.zhh_endAppearanceTransition()
            }

            return
        }

        _selectedViewController?.zhh_beginAppearanceTransition(false, animated: true)

        if draggingForward {
            if backwardViewController?.isAppearing != nil {
                backwardViewController?.zhh_beginAppearanceTransition(false, animated: false)
                backwardViewController?.zhh_endAppearanceTransition()
            }

            forwardViewController?.zhh_beginAppearanceTransition(true, animated: true)
        } else {
            if forwardViewController?.isAppearing != nil {
                forwardViewController?.zhh_beginAppearanceTransition(false, animated: false)
                forwardViewController?.zhh_endAppearanceTransition()
            }

            backwardViewController?.zhh_beginAppearanceTransition(true, animated: true)
        }

        if !isInTransition { isInTransition = true }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // If when new dragging initiatied, last dragging is still in progress.
        // End appearance transition immediately
        // And set selectedIndex to willAppear view controller
        let appearingViewControllers = Set(loadedViewControllers.filter { $0.isAppearing == true })
        assert(appearingViewControllers.count <= 1)
        loadedViewControllers.filter { $0.isAppearing != nil }.forEach { $0.zhh_endAppearanceTransition() }

        if let willAppearViewController = appearingViewControllers.first {
            _selectedIndex = loadedViewControllers.index(of: willAppearViewController)!
        }

        beginDraggingContentOffsetX = nil
        willEndDraggingTargetContentOffsetX = nil

        isDragging = true
        beginDraggingContentOffsetX = scrollView.contentOffset.x
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDragging = false
        guard let beginDraggingContentOffsetX = beginDraggingContentOffsetX else {
            return
        }
        willEndDraggingTargetContentOffsetX = targetContentOffset.pointee.x
        if willEndDraggingTargetContentOffsetX == beginDraggingContentOffsetX {
            // If will end equals begin dragging content offset x, which means dragging cancels
            _selectedViewController?.zhh_beginAppearanceTransition(true, animated: true)

            if forwardViewController?.isAppearing != nil {
                forwardViewController?.zhh_beginAppearanceTransition(false, animated: true)
            }

            if backwardViewController?.isAppearing != nil {
                backwardViewController?.zhh_beginAppearanceTransition(false, animated: true)
            }
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // If dragging ends at separator point, clean state
        if scrollView.contentOffset.x.truncatingRemainder(dividingBy: view.bounds.width) == 0 {
            loadedViewControllers.filter { $0.isAppearing != nil }.forEach { $0.zhh_endAppearanceTransition() }
            _selectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
            beginDraggingContentOffsetX = nil
            willEndDraggingTargetContentOffsetX = nil
            assert(loadedViewControllers.filter { $0.isAppearing != nil }.isEmpty)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isInTransition = false
        // If for some reasons, scrollView.contentOffset.x is not matched with willEndDraggingTargetContentOffset
        // End current transitions
        // Add missing transitions
        guard let willEndDraggingTargetContentOffsetX = willEndDraggingTargetContentOffsetX else {
            return
        }
        if willEndDraggingTargetContentOffsetX != scrollView.contentOffset.x {
            let appearingViewControllers = Set(loadedViewControllers.filter { $0.isAppearing == true })
            assert(appearingViewControllers.count <= 1)

            // End current transitions
            loadedViewControllers.filter { $0.isAppearing != nil }.forEach { $0.zhh_endAppearanceTransition() }

            if let willAppearViewController = appearingViewControllers.first {
                _selectedIndex = loadedViewControllers.index(of: willAppearViewController)!

                // Add missing transitions
                _selectedViewController?.zhh_beginAppearanceTransition(false, animated: false)
                _selectedViewController?.zhh_endAppearanceTransition()

                let willSelectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
                let willSelectedViewController = viewControllerForIndex(willSelectedIndex)
                willSelectedViewController?.zhh_beginAppearanceTransition(true, animated: false)
                willSelectedViewController?.zhh_endAppearanceTransition()
                _selectedIndex = willSelectedIndex
            }
        } else {
            loadedViewControllers.filter { $0.isAppearing != nil }.forEach { $0.zhh_endAppearanceTransition() }
            _selectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
        }

        beginDraggingContentOffsetX = nil
        self.willEndDraggingTargetContentOffsetX = nil

        assert(loadedViewControllers.filter { $0.isAppearing != nil }.isEmpty)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isInTransition = false
        loadedViewControllers.filter { $0.isAppearing != nil }.forEach { $0.zhh_endAppearanceTransition() }
        _selectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
        setSelectedIndexCompletion?(true)
        setSelectedIndexCompletion = nil
    }
}

// MARK: - ViewController Appearance State Swizzling
extension UIViewController {
    enum AssociatedKeys {
        static var AppearanceStateKey = "zhh_AppearanceStateKey"
    }
}

private extension UIViewController {
    /// Store `isAppearing` in beginAppearanceTransition
    /// `nil` means `beginAppearanceTransition` not get called
    /// `true` means `beginAppearanceTransition` called with `isAppearing: true`, view controller is appearning
    /// `false` means `beginAppearanceTransition` called with `isAppearing: false`, view controller is disappearning
    var isAppearing: Bool? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.AppearanceStateKey) as? Bool }
        set { objc_setAssociatedObject(self, &AssociatedKeys.AppearanceStateKey, newValue as Bool?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /**
     Wrapper on `beginAppearanceTransition`, this will ignore successive calls with same isAppearing

     - parameter isAppearing: isAppearing description
     - parameter animated:    animated description
     */
    func zhh_beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        if self.isAppearing != isAppearing {
            beginAppearanceTransition(isAppearing, animated: animated)
            self.isAppearing = isAppearing
        }
    }

    /**
     Wrapper on `endAppearanceTransition`, this will avoid unnecessary calls if there's no `beginAppearanceTransition` is called.
     */
    func zhh_endAppearanceTransition() {
        if isAppearing != nil {
            endAppearanceTransition()
            isAppearing = nil
        }
    }
}
