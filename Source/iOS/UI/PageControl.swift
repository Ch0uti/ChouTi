//
//  PageControl.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-06-09.
//
//

import UIKit

// TODO: Handle touch

public class PageControl: UIControl {
    public private(set) var currentPage: Int = 0
    public var numberOfPages: Int = 0 {
        didSet {
            precondition(numberOfPages >= 0, "number of pages must a postive number")
            currentPage.normalizeInPlace(0, numberOfPages)
            setupDots()
        }
    }
    
    public var pageIndicatorTintColor: UIColor = UIColor(white: 1.0, alpha: 0.2) {
        didSet {
            // TODO:
        }
    }
    
    public var currentPageIndicatorTintColor: UIColor = UIColor.whiteColor() {
        didSet {
            // TODO:
        }
    }
    
    public var pageIndicatorSize: CGFloat = 7.0 {
        didSet {
            // TODO:
        }
    }
    
    public var pageIndicatorSpacing: CGFloat = 9.0 {
        didSet {
            // TODO:
        }
    }
    
    // MARK: - Private
    private var dots: [CAShapeLayer] = []
    private var currentDot = CAShapeLayer()
    private let animationDuration: NSTimeInterval = 1.0
    
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
        if setCurrentPageIsInProgress { return }
        
        print("layout subviews")
        
        currentDot.position = center(forIndex: currentPage)
        for (index, dot) in dots.enumerate() {
            dot.position = center(forIndex: index)
        }
    }
    
    public override func intrinsicContentSize() -> CGSize {
        let width = lengthFromFirstDotCenterToLastDotCenter + spacingBetweenDotCenter * 2
        let height = max(pageIndicatorSpacing * 2, 37)
        
        return CGSize(width: width, height: height)
    }
}

extension PageControl {
    
    public func set(currentPage currentPage: Int, animated: Bool) {
        set(currentPage: currentPage, progress: 1.0, animated: animated)
    }
    
    public func set(currentPage currentPage: Int, progress: CGFloat) {
        let progress = progress.normalize()
        set(currentPage: currentPage, progress: progress, animated: false)
    }
    
    private func set(currentPage currentPage: Int, progress: CGFloat, animated: Bool) {
        if self.currentPage == currentPage { return }
        
        // begin frame, end frame
        let fromPosition = center(forIndex: self.currentPage)
        let targetPosition = center(forIndex: currentPage)
        let toPosition = CGPoint(x: fromPosition.x + (targetPosition.x - fromPosition.x) * progress,
                              y: fromPosition.y + (targetPosition.y - fromPosition.y) * progress)
        
        // size
        let indicatorSize = CGSize(width: pageIndicatorSize, height: pageIndicatorSize)
        let distanceBetweenFromPositionToTargetPosition = abs(fromPosition.x - targetPosition.x)
        let mostlyExpandedSize = CGSize(width: distanceBetweenFromPositionToTargetPosition + pageIndicatorSize,
                                        height: pageIndicatorSize)
        
        // progress:   0.0 -> 0.2 -> 0.5 -> 0.7 -> 1.0
        // size.width: 0.0 -> 0.4 -> 1.0 -> 0.6 -> 0.0 * distance from fromPosition.x to targetPosition.x + indicator size
        let distanceToHalf = abs(progress - 0.5)
        let sizeFactor = 2 * (0.5 - distanceToHalf)
        
        // update to final state
        currentDot.bounds.size = CGSize(width: distanceBetweenFromPositionToTargetPosition * sizeFactor + pageIndicatorSize, height: pageIndicatorSize)
        currentDot.position = toPosition
        if progress == 1.0 {
            self.currentPage = currentPage
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

extension PageControl {
    private func setupDots() {
        // Setup current dot
        if currentDot.superlayer == nil {
            currentDot.bounds = CGRect(x: 0, y: 0, width: pageIndicatorSize, height: pageIndicatorSize)
            currentDot.backgroundColor = currentPageIndicatorTintColor.CGColor
            currentDot.cornerRadius = pageIndicatorSize / 2.0
            layer.addSublayer(currentDot)
        }
        
        // TODO: Improve
        // Setup othet dots
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
