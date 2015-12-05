//
//  ZHDropDownMenu.swift
//  UW Quest
//
//  Created by Honghao Zhang on 1/22/15.
//  Copyright (c) 2015 Honghao. All rights reserved.
//

import UIKit

public protocol ZHDropDownMenuDataSource {
    func numberOfItemsInDropDownMenu(menu: ZHDropDownMenu) -> Int
    func zhDropDownMenu(menu: ZHDropDownMenu, itemTitleForIndex index: Int) -> String
}

public protocol ZHDropDownMenuDelegate {
    func zhDropDownMenu(menu: ZHDropDownMenu, didSelectIndex index: Int)
}

public class ZHDropDownMenu: UIControl {
    // WrapperView is used for holding all of views to make a better animation
    private var wrapperView: UIView!
    private var cWrapperViewTop: NSLayoutConstraint!
    private var cWrapperViewLeft: NSLayoutConstraint!
    private var cWrapperViewBottom: NSLayoutConstraint!
    private var cWrapperViewRight: NSLayoutConstraint!
    
    public var titleLabel: UILabel!
    
    private var indicatorLayer: CAShapeLayer!
    private var indicatorView: UIView!
    private let kIndicatorWidth: CGFloat = 8.0
    private var contentInset: UIEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    private var kAnimationDuration: NSTimeInterval = 0.25
    
    var textColor: UIColor = UIColor(white: 0.0, alpha: 0.7) {
        didSet {
            titleLabel.textColor = textColor
            indicatorLayer = createTriangleIndicatorWithColor(textColor, width: kIndicatorWidth)
        }
    }
    
    var titleFont: UIFont = UIFont(name: "HelveticaNeue-Light", size: 17)! {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var selectedFont: UIFont = UIFont(name: "HelveticaNeue", size: 17)!
    
    var cornerRaidus: CGFloat = 4 {
        didSet {
            wrapperView.layer.cornerRadius = cornerRaidus
            tableView.layer.cornerRadius = cornerRaidus
        }
    }
    
    // Data
    var currentSelectedIndex: Int = -1 {
        didSet {
            if self.dataSource != nil {
                tableView.selectRowAtIndexPath(NSIndexPath(forRow: currentSelectedIndex, inSection: 0), animated: true, scrollPosition: .None)
                currentTitle = self.dataSource!.zhDropDownMenu(self, itemTitleForIndex: currentSelectedIndex)
            }
        }
    }
    
    var currentTitle: String = "(Not selected)" {
        didSet {
            if titleLabel.layer.animationForKey("TextTransition") == nil {
                // Add transition (must be called after myLabel has been displayed)
                let animation = CATransition()
                animation.duration = kAnimationDuration
                animation.type = kCATransitionFade
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                titleLabel.layer.addAnimation(animation, forKey: "TextTransition")
            }
            
            if currentTitle.characters.count == 0 { currentTitle = " " }
            
            titleLabel.text = currentTitle
        }
    }
    
    var isExpandingOngoing: Bool = false
    public var expanded: Bool = false {
        didSet {
            if self.superview == nil {
                return
            }
            let rootSuperView = self.rootView()!
            if expanded {
                isExpandingOngoing = true
                addOpaqueOverlayViewForView(rootSuperView)
                // Move wrapper view to top most
                rootSuperView.addSubview(wrapperView)
                rootSuperView.addConstraints([cWrapperViewTop, cWrapperViewLeft, cWrapperViewBottom, cWrapperViewRight])
                
                // Move table view to the top
                rootSuperView.insertSubview(tableView, belowSubview: wrapperView)
                rootSuperView.addConstraints([cTableViewWidth, cTableViewCenterX, cTableViewTop])
                tableView.addBackupBlurView(tag: 101, animated: false, completion: nil)
                rootSuperView.layoutIfNeeded()
                
                cTableViewTop.constant = self.bounds.height + 2
                let rowsCount: Int = tableView.numberOfRowsInSection(0)
                cTableViewHeight.constant = rowHeight * CGFloat(min(rowsCount, maxExpandingItems))
                
                // Animation
                wrapperView.addBackupBlurView(tag: 100, animated: true, completion: nil)
                UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
                    self.wrapperView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
                    self.tableView.alpha = 1.0
                    // Choose 179.9 to make sure rotation is clockwise
                    self.indicatorView.transform = CGAffineTransformMakeRotation(CGFloat(179.9).radianDegree)
                    rootSuperView.layoutIfNeeded()
                }, completion: { finished -> Void in
                    self.indicatorView.transform = CGAffineTransformMakeRotation(CGFloat(180.0).radianDegree)
                    self.isExpandingOngoing = false
                })
            } else {
                isExpandingOngoing = true
                
                // Move table view back to self
                cTableViewTop.constant = 0
                cTableViewHeight.constant = 2.0
                
                // Animation
                wrapperView.removeBackBlurView(tag: 100, animated: true, completion: nil)
                UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
                    self.wrapperView.backgroundColor = UIColor.clearColor()
                    self.tableView.alpha = 0
                    // Choose 0.1 to make sure rotation is counter-clockwise
                    self.indicatorView.transform = CGAffineTransformMakeRotation(CGFloat(0.1).radianDegree)
                    rootSuperView.layoutIfNeeded()
                }, completion: { finished -> Void in
                    self.indicatorView.transform = CGAffineTransformMakeRotation(CGFloat(0).radianDegree)
                    self.tableView.removeBackBlurView(tag: 101, animated: false, completion: nil)
                    self.tableView.removeFromSuperview()
                    self.addSubview(self.wrapperView)
                    self.addConstraints([self.cWrapperViewTop, self.cWrapperViewLeft, self.cWrapperViewBottom, self.cWrapperViewRight])
                    self.layoutIfNeeded()
                    self.removeOpaqueOverlayViewForView(rootSuperView)
                    self.isExpandingOngoing = false
                })
            }
        }
    }
    
    // tableView is for showing options, it will be below wrapper view
    var tableView: UITableView!
    let kCellIdentifier = "CellIndentifier"
    
    public var maxExpandingItems: Int = 4
    
    // tableView.top <=> self.top
    private var cTableViewTop: NSLayoutConstraint!
    private var cTableViewCenterX: NSLayoutConstraint!
    private var cTableViewWidth: NSLayoutConstraint!
    private var cTableViewHeight: NSLayoutConstraint!
    
    public var dataSource: ZHDropDownMenuDataSource?
    public var delegate: ZHDropDownMenuDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupViews()
        setupActions()
    }
    
    private func setupViews() {
        backgroundColor = UIColor.clearColor()
        
        // WrapperView
        wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperView)
        
        cWrapperViewTop = NSLayoutConstraint(item: wrapperView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0)
        cWrapperViewLeft = NSLayoutConstraint(item: wrapperView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0)
        cWrapperViewBottom = NSLayoutConstraint(item: wrapperView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
        cWrapperViewRight = NSLayoutConstraint(item: wrapperView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0)
        self.addConstraints([cWrapperViewTop, cWrapperViewLeft, cWrapperViewBottom, cWrapperViewRight])
        
        wrapperView.userInteractionEnabled = false
        wrapperView.backgroundColor = UIColor.clearColor()
        
        // TitleLabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(titleLabel)
        // Triangle Indicator
        indicatorView = UIView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(indicatorView)
        
        let top = NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: wrapperView, attribute: .Top, multiplier: 1.0, constant: contentInset.top)
        let left = NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: wrapperView, attribute: .Left, multiplier: 1.0, constant: contentInset.left)
        let bottom = NSLayoutConstraint(item: titleLabel, attribute: .Bottom, relatedBy: .Equal, toItem: wrapperView, attribute: .Bottom, multiplier: 1.0, constant: -contentInset.bottom)
        let right = NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: indicatorView, attribute: .Left, multiplier: 1.0, constant: -contentInset.right)
        wrapperView.addConstraints([top, left, bottom, right])
        
        let width = NSLayoutConstraint(item: indicatorView, attribute: .Width, relatedBy: .Equal, toItem: indicatorView, attribute: .Width, multiplier: 0, constant: kIndicatorWidth)
        let height = NSLayoutConstraint(item: indicatorView, attribute: .Height, relatedBy: .Equal, toItem: indicatorView, attribute: .Height, multiplier: 0, constant: (ceil(sin((60.0 as CGFloat).radianDegree) as CGFloat) as CGFloat) * kIndicatorWidth)
        indicatorView.addConstraints([width, height])
        
        let verticalCenter = NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: indicatorView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        let indicatorViewRight = NSLayoutConstraint(item: indicatorView, attribute: .Right, relatedBy: .Equal, toItem: wrapperView, attribute: .Right, multiplier: 1.0, constant: -contentInset.right)
        wrapperView.addConstraints([verticalCenter, indicatorViewRight])
        
        titleLabel.setContentHuggingPriority(250, forAxis: .Horizontal)
        titleLabel.setContentHuggingPriority(1000, forAxis: .Vertical)
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        
        titleLabel.textAlignment = .Right
        titleLabel.font = titleFont
        
        titleLabel.text = currentTitle
        
        // Triangle Indicator
        indicatorLayer = createTriangleIndicatorWithColor(textColor, width: kIndicatorWidth)
        indicatorView.layer.addSublayer(indicatorLayer)
        
        setupTableView()
        wrapperView.clipsToBounds = true
        cornerRaidus = 4.0
    }
    
    private func setupActions() {
        self.addTarget(self, action: "tapped:forEvent:", forControlEvents: .TouchUpInside)
    }
    
    func tapped(sender: AnyObject, forEvent event: UIEvent) {
        if !isExpandingOngoing {
            expanded = !expanded
        }
    }
}

// MARK: TableView
extension ZHDropDownMenu: UITableViewDataSource, UITableViewDelegate {
    class ZHDropDownItemCell: UITableViewCell {
        var titleLabel: UILabel!
        var cTitleLabelRight: NSLayoutConstraint!
        var titleLabelRightPadding: CGFloat = 8 {
            didSet {
                cTitleLabelRight.constant = -titleLabelRightPadding
            }
        }
        
        var selectedColor: UIColor = UIColor(white: 0.7, alpha: 0.2) {
            didSet {
                self.selectedBackgroundView?.backgroundColor = selectedColor.colorWithAlphaComponent(0.1)
            }
        }
        
        var normalFont: UIFont = UIFont(name: "HelveticaNeue-Light", size: 17)!
        var selectedFont: UIFont = UIFont(name: "HelveticaNeue", size: 17)!
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
		
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(titleLabel)
            
            let centerY = NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
            cTitleLabelRight = NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .Right, multiplier: 1.0, constant: -titleLabelRightPadding)
            self.contentView.addConstraints([centerY, cTitleLabelRight])
            
            titleLabel.setContentHuggingPriority(1000, forAxis: .Horizontal)
            titleLabel.setContentHuggingPriority(1000, forAxis: .Vertical)
            titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
            titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
            
            titleLabel.textAlignment = .Right
            titleLabel.font = normalFont
            
            self.selectedBackgroundView = UIView()
            self.selectedBackgroundView?.backgroundColor = selectedColor
        }
        
        override func setSelected(selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            if selected {
                titleLabel.font = selectedFont
            } else {
                titleLabel.font = normalFont
            }
        }
    }
    
    var rowHeight: CGFloat { return self.titleLabel.bounds.height + 10 }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView.registerClass(ZHDropDownItemCell.self , forCellReuseIdentifier: kCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup constraints, but won't add to view, will add it when expanding
        cTableViewHeight = NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: tableView, attribute: .Height, multiplier: 0.0, constant: 2.0)
        tableView.addConstraint(cTableViewHeight)
        
        cTableViewWidth = NSLayoutConstraint(item: tableView, attribute: .Width, relatedBy: .Equal, toItem: wrapperView, attribute: .Width, multiplier: 1.0, constant: 0.0)
        cTableViewCenterX = NSLayoutConstraint(item: tableView, attribute: .CenterX, relatedBy: .Equal, toItem: wrapperView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        cTableViewTop = NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: wrapperView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        
        tableView.alpha = 0.0
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = cornerRaidus
        tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        
        tableView.separatorStyle = .None
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(2, 2, 2, self.contentInset.right)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // Data Source
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource == nil {
            assertionFailure("dataSource cannot be nil")
			return 0
        } else {
            return dataSource!.numberOfItemsInDropDownMenu(self)
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as AnyObject! as! ZHDropDownItemCell
        cell.titleLabelRightPadding = contentInset.right * 2 + kIndicatorWidth
        cell.titleLabel.textColor = textColor
        cell.selectedColor = textColor
        cell.titleLabel.font = self.titleLabel.font
        cell.backgroundColor = UIColor.clearColor()
        
        cell.titleLabel?.text = self.dataSource!.zhDropDownMenu(self, itemTitleForIndex: indexPath.row)
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    // Delegate
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.expanded = false
        currentSelectedIndex = indexPath.row
        delegate?.zhDropDownMenu(self, didSelectIndex: indexPath.row)
    }
}

// MARK: Helper
extension ZHDropDownMenu {
    func createTriangleIndicatorWithColor(color: UIColor, width: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.contentsScale = UIScreen.mainScreen().scale
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(width, 0))
        path.addLineToPoint(CGPointMake(width / 2.0, (sin((60.0 as CGFloat).radianDegree) as CGFloat) * width))
        path.closePath()
        
        layer.path = path.CGPath
        layer.lineWidth = 1.0
        layer.fillColor = color.CGColor
        
        return layer
    }
    
    /**
    Find the root parent view
    
    :returns: root parent view
    */
    func rootView() -> UIView? {
        if self.superview == nil {
            return nil
        }
        var currentSuperView = self.superview!
        while currentSuperView.superview != nil {
            currentSuperView = currentSuperView.superview!
        }
        return currentSuperView
    }
    
    // MARK: added overlay view for root view
    /// This number is used for tagging overlay view
    var magicTagNumber: Int { return 9999 }
    
    func addOpaqueOverlayViewForView(view: UIView) {
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.tag = magicTagNumber
        view.addSubview(overlayView)
        
        overlayView.fullSizeAsSuperView()
        
        let touchSelector = Selector("rootViewIsTouched:")
        let tapGesture = UITapGestureRecognizer(target: self, action: touchSelector)
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    func removeOpaqueOverlayViewForView(view: UIView) {
        let overlayView: UIView? = view.viewWithTag(magicTagNumber)
        overlayView?.removeFromSuperview()
    }
    
    func rootViewIsTouched(gesture: UIGestureRecognizer) {
        if !isExpandingOngoing {
            expanded = false
        }
    }
    
    // MARK: Add cover view for current showing title
}

extension UIView {
    func fullSizeAsSuperView() {
        if self.superview == nil {
            return
        }
        self.superview!.addConstraints(self.constrainsFromFullSizeAsView(self.superview!))
    }
    
    func constrainsFromFullSizeAsView(view: UIView) -> [NSLayoutConstraint] {
        let top = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0)
        let left = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let right = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0)
        return [top, left, bottom, right]
    }
    
    // MARK: Add blur view
    func addBackupBlurView(tag tag: Int, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        if self.superview == nil {
            return
        }
        var blurView: UIView!
        if isIOS8 {
            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            blurView = UIVisualEffectView(effect: blurEffect)
        } else {
            blurView = UIView()
            blurView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        }
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        blurView.tag = tag // Special number for taging this blurView
        blurView.alpha = 0
        blurView.clipsToBounds = self.clipsToBounds
        blurView.layer.cornerRadius = self.layer.cornerRadius
        blurView.userInteractionEnabled = false
        
        // Setup constraints
        self.superview!.insertSubview(blurView!, belowSubview: self)
        self.superview!.addConstraints(blurView!.constrainsFromFullSizeAsView(self))
        blurView!.setNeedsLayout()
        blurView!.layoutIfNeeded()
        
        if animated {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                blurView.alpha = 1.0
                }, completion: { finished -> Void in
                    if completion != nil { completion!(finished) }
            })
        } else {
            blurView.alpha = 1.0
        }
    }
    
    func removeBackBlurView(tag tag: Int, animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        if self.superview == nil {
            return
        }
        if let blurView = self.superview!.viewWithTag(tag) {
            if animated {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    blurView.alpha = 0.0
                    }, completion: { finished -> Void in
                        blurView.removeFromSuperview()
                        if completion != nil { completion!(finished) }
                })
            } else {
                blurView.removeFromSuperview()
            }
        }
    }
}
