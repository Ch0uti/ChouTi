//
//  PageControl.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-06-09.
//
//

import UIKit

public class PageControl: UIControl {
    
    private var _currentPage: Int = 0 { didSet { sendActionsForControlEvents(.ValueChanged) } }
    /// The current page, shown by the receiver as a white dot.
    public var currentPage: Int {
        get { return _currentPage }
        set { set(currentPage: newValue, animated: false) }
    }
    
    /// The number of pages the receiver shows (as dots).
    public var numberOfPages: Int = 0 {
        didSet {
            precondition(numberOfPages >= 0, "number of pages must a postive number")
            _currentPage.normalizeInPlace(0, numberOfPages)
            setupDots()
        }
    }
    
    /// The tint color to be used for the page indicator.
    public var pageIndicatorTintColor: UIColor = UIColor(white: 1.0, alpha: 0.2) {
        didSet {
            dots.forEach { $0.backgroundColor = pageIndicatorTintColor.CGColor }
        }
    }
    
    /// The tint color to be used for the current page indicator.
    public var currentPageIndicatorTintColor: UIColor = UIColor.whiteColor() {
        didSet {
			currentDot.backgroundColor = currentPageIndicatorTintColor.CGColor
        }
    }
    
    /// Page indicator size/
    public var pageIndicatorSize: CGFloat = 7.0 {
        didSet {
            if oldValue == pageIndicatorSize { return }
            currentDot.bounds = CGRect(x: 0, y: 0, width: pageIndicatorSize, height: pageIndicatorSize)
            currentDot.cornerRadius = pageIndicatorSize / 2.0
            
            dots.forEach {
                $0.bounds = CGRect(x: 0, y: 0, width: pageIndicatorSize, height: pageIndicatorSize)
                $0.cornerRadius = pageIndicatorSize / 2.0
            }
            
            invalidateIntrinsicContentSize()
    
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// Spacings between two indicators.
    public var pageIndicatorSpacing: CGFloat = 9.0 {
        didSet {
            if oldValue == pageIndicatorSpacing { return }
            if setCurrentPageIsInProgress {
                set(currentPage: _currentPage, progress: 1.0, animated: true)
            }
            
            invalidateIntrinsicContentSize()
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// scrollView the page control binds
    public weak var scrollView: UIScrollView? {
        didSet {
            if let oldScrollView = oldValue {
                scrollViewObserver.removeObservation(oldScrollView, forKeyPath: "contentOffset")
            }
            
            if let scrollView = scrollView {
                scrollViewObserver.observe(scrollView, forKeyPath: "contentOffset") { [weak self] (object, oldValue, newValue) in
                    self?.update(withScrollView: scrollView)
                }
            }
        }
    }
    
    lazy private var scrollViewObserver: Observer = Observer()
    
    // MARK: - Private
    /// Unhighlighted indicators
    private var dots: [CAShapeLayer] = []
    
    /// Highlighted indicator
    private var currentDot = CAShapeLayer()
    
    private let animationDuration: NSTimeInterval = 0.333
    
    /// true if current page index is being set in progress.
    private var setCurrentPageIsInProgress: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        commonInit()
    }
    
    private func commonInit() {
        setupDots()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
                
        for (index, dot) in dots.enumerate() {
            dot.position = center(forIndex: index)
            dot.removeAllAnimations()
        }
        
        // if current page index is being updated in progress, avoid updating position
        if setCurrentPageIsInProgress { return }
        currentDot.position = center(forIndex: _currentPage)
        currentDot.removeAllAnimations()
    }
    
    public override func intrinsicContentSize() -> CGSize {
        let width = lengthFromFirstDotCenterToLastDotCenter + spacingBetweenDotCenter * 2
        let height = max(pageIndicatorSpacing * 2, 37)
        
        return CGSize(width: width, height: height)
    }
    
    public override func removeFromSuperview() {
        scrollView = nil
        super.removeFromSuperview()
    }
    
    deinit {
        scrollView = nil
    }
}

// MARK: - Update currentPage
extension PageControl {
    /**
     Set current page to new index with animation.
     
     - parameter currentPage: New page index.
     - parameter animated:    animated or not.
     */
    public func set(currentPage currentPage: Int, animated: Bool) {
        set(currentPage: currentPage, progress: 1.0, animated: animated)
        
        // update scroll view content offset
        if let scrollView = scrollView {
            guard scrollView.bounds.width > 0 else { return }
            let contentOffset = CGPoint(x: CGFloat(currentPage) * scrollView.bounds.width, y: scrollView.contentOffset.y)
            
            // updating currentPage will also update scrollView's contentOffset, however, we don't want the observation cause setting current page again. Thus, pasue observation for the moment.
            scrollViewObserver.pauseObservation = true
            UIView.animateWithDuration(animationDuration, animations: { 
                scrollView.contentOffset = contentOffset
                }, completion: { [weak self] _ in
                    // restore the contentOffset observation once animated setting contentOffset ends.
                    self?.scrollViewObserver.pauseObservation = false
            })
        }
    }
    
    /**
     Set to new page index with a progress.
     Note: Make sure call it with 1.0
     
     - parameter currentPage: New page index.
     - parameter progress:    Progress from current index to new index, 0 to 1, inclusive.
     */
    public func set(currentPage currentPage: Int, progress: CGFloat) {
        let progress = progress.normalize()
        set(currentPage: currentPage, progress: progress, animated: false)
    }
    
    private func set(currentPage currentPage: Int, progress: CGFloat, animated: Bool) {
        // sanitize new current page
        if (currentPage < 0 || currentPage >= numberOfPages) {
            print("Warning: setting currentPage: \(currentPage) is out of range from 0 ... \(numberOfPages - 1)")
        }
        let currentPage = currentPage.normalize(0, numberOfPages - 1)
        
        if self._currentPage == currentPage { return }
        
        // begin frame, end frame
        let fromPosition = center(forIndex: self._currentPage)
        let targetPosition = center(forIndex: currentPage)
        let toPosition = CGPoint(x: fromPosition.x + (targetPosition.x - fromPosition.x) * progress,
                              y: fromPosition.y + (targetPosition.y - fromPosition.y) * progress)
        
        // size
        let indicatorSize = CGSize(width: pageIndicatorSize, height: pageIndicatorSize)
        // 0.75 make the animation cooler
        let distanceBetweenFromPositionToTargetPosition = abs(fromPosition.x - targetPosition.x) * 0.75
        let mostlyExpandedSize = CGSize(width: distanceBetweenFromPositionToTargetPosition + pageIndicatorSize,
                                        height: pageIndicatorSize)
        
        // progress:   0.0 -> 0.2 -> 0.5 -> 0.7 -> 1.0
        // size.width: 0.0 -> 0.4 -> 1.0 -> 0.6 -> 0.0 * distance from fromPosition.x to targetPosition.x + indicator size
        let distanceToHalf = abs(progress - 0.5)
        let sizeFactor = 2 * (0.5 - distanceToHalf)
        
        // update to final state
        currentDot.bounds.size = CGSize(width: distanceBetweenFromPositionToTargetPosition * sizeFactor + pageIndicatorSize, height: pageIndicatorSize)
        currentDot.position = toPosition
        
        if progress == 0.0 {
            setCurrentPageIsInProgress = false
        } else if progress == 1.0 {
            self._currentPage = currentPage
            setCurrentPageIsInProgress = false
        } else {
            setCurrentPageIsInProgress = true
        }
        
        if animated {
            // add animations
            let sizeAnimation = CAKeyframeAnimation(keyPath: "bounds.size")
            sizeAnimation.values = [NSValue(CGSize: indicatorSize), NSValue(CGSize: mostlyExpandedSize), NSValue(CGSize: indicatorSize)]
            sizeAnimation.keyTimes = [0.0, 0.5, 1.0]
            
            let positionAnimation = CAKeyframeAnimation(keyPath: "position")
            positionAnimation.values = [NSValue(CGPoint: fromPosition), NSValue(CGPoint: toPosition)]
            positionAnimation.keyTimes = [0.0, 1.0]
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.duration = animationDuration
            groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            groupAnimation.fillMode = kCAFillModeBackwards
            groupAnimation.animations = [sizeAnimation, positionAnimation]
            
            currentDot.addAnimation(groupAnimation, forKey: nil)
        } else {
            currentDot.removeAllAnimations()
        }
    }
}

// MARK: - ScrollView
extension PageControl {
    /**
     Update current indicator with scroll view
     
     - parameter scrollView: scroll view
     */
    private func update(withScrollView scrollView: UIScrollView) {
        if scrollView.width == 0 { return }
        
        let offset = scrollView.contentOffset.x
        let progress = (offset - CGFloat(_currentPage) * scrollView.width) / scrollView.width
        if progress == 0 {
            return
        }
        let newIndex = progress > 0 ? _currentPage + 1 : _currentPage - 1
        
        set(currentPage: newIndex, progress: abs(progress))
    }
}

// MARK: - Touch Handling
extension PageControl {
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        guard let location = touch?.locationInView(self) else { return }
        let currentDotCenterX = currentDot.frame.origin.x + pageIndicatorSize / 2.0
        
        if location.x - currentDotCenterX > pageIndicatorSpacing / 2.0 {
            set(currentPage: _currentPage + 1, animated: true)
        } else if location.x - currentDotCenterX < -pageIndicatorSpacing / 2.0 {
            set(currentPage: _currentPage - 1, animated: true)
        }
        
        super.endTrackingWithTouch(touch, withEvent: event)
    }
}

// MARK: - Private Helpers
extension PageControl {
    /**
     Setup unhighlighted dots and current dot
     */
    private func setupDots() {
        // Setup current dot
        if currentDot.superlayer == nil {
            currentDot.bounds = CGRect(x: 0, y: 0, width: pageIndicatorSize, height: pageIndicatorSize)
            currentDot.backgroundColor = currentPageIndicatorTintColor.CGColor
            currentDot.cornerRadius = pageIndicatorSize / 2.0
            layer.addSublayer(currentDot)
        }
        
        // Setup other dots
        dots.forEach { $0.removeFromSuperlayer() }
        dots.removeAll()
        
        for _ in 0 ..< numberOfPages {
            let dot = CAShapeLayer()
            dot.bounds = CGRect(x: 0, y: 0, width: pageIndicatorSize, height: pageIndicatorSize)
            dot.backgroundColor = pageIndicatorTintColor.CGColor
            dot.cornerRadius = pageIndicatorSize / 2.0
            
            layer.insertSublayer(dot, below: currentDot)
            dots.append(dot)
        }
    }
    
    /// Length between edge of two dots
    private var spacingBetweenDotCenter: CGFloat { return pageIndicatorSize + pageIndicatorSpacing }
    
    private var lengthFromFirstDotCenterToLastDotCenter: CGFloat {
        return CGFloat(numberOfPages - 1) * spacingBetweenDotCenter
    }
    
    /**
     Get center for dot index
     
     - parameter index: dot index
     
     - returns: center
     */
    private func center(forIndex index: Int) -> CGPoint {
        guard numberOfPages > 0 else { fatalError("numberOfPages is less than 1.") }
        
        let firstDotCenterX = (width - lengthFromFirstDotCenterToLastDotCenter) / 2.0
        let x = firstDotCenterX + CGFloat(index) * spacingBetweenDotCenter
        return CGPoint(x: x, y: height / 2.0)
    }
    
    /**
     Get frame for dot center
     
     - parameter forCenter: dot center
     
     - returns: frame of dot
     */
    private func frame(forCenter center: CGPoint) -> CGRect {
        return CGRect(x: center.x - pageIndicatorSize / 2.0, y: center.y - pageIndicatorSize / 2.0, width: pageIndicatorSize, height: pageIndicatorSize)
    }
}
