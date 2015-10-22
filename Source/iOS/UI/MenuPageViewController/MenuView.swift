//
//  MenuView.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-11.
//
//

import UIKit

public protocol MenuViewDataSource: class {
	/**
	Quering for number of menus
	
	- parameter menuView: the menuView
	
	- returns: number of menus
	*/
	func numberOfMenusInMenuView(menuView: MenuView) -> Int
	
	/**
	Asking for view for menu view
	
	- parameter menuView:    the menuView
	- parameter index:       menuView index
	- parameter contentView: contentView of the menuView, this could be nil. If it's not nil, delegate can add returned view on the contentView, which enable delegte to use AutoLayout to setup view layout
	
	- returns: A view
	*/
	func menuView(menuView: MenuView, menuViewForIndex index: Int, contentView: UIView?) -> UIView
}

public protocol MenuViewDelegate: class {
	/**
	Quering for width for a menu view
	
	- parameter menuView: the menu view
	- parameter index:    index
	
	- returns: width for the menu view
	*/
	func menuView(menuView: MenuView, menuWidthForIndex index: Int) -> CGFloat
	
	func menuView(menuView: MenuView, didScrollToOffset offset: CGFloat)
	
	func menuView(menuView: MenuView, didSelectIndex selectedIndex: Int)
}



public class MenuView : UIView {
	// MARK: - Enums
	// TODO: to complete
	public enum ScrollingOption {
		case None
		case Leading
		case Center
	}
	
	// MARK: - Public
	public var menuCollectionView: UICollectionView!
	public let menuCollectionViewLayout = UICollectionViewFlowLayout()
	
	public var spacingsBetweenMenus: CGFloat {
		get { return menuCollectionViewLayout.minimumLineSpacing }
		set {
			menuCollectionViewLayout.minimumLineSpacing = newValue
//			switch scrollingOption {
//			case .None: break
//			case .Leading: menuCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: newValue, bottom: 0.0, right: newValue)
//			case .Center: break
//			}
		}
	}
	
	public weak var dataSource: MenuViewDataSource?
	public weak var delegate: MenuViewDelegate?
	
	public var scrollingOption: ScrollingOption = .Center
	
	// TODO: turn scroll enable turn when ready, contentInset updating is not completed
	public var scrollEnabled: Bool = false {
		didSet {
			menuCollectionView.scrollEnabled = scrollEnabled
		}
	}
	
	private var _selectedIndex: Int = 0
	public var selectedIndex: Int {
		get { return _selectedIndex }
		set {
			precondition(0 <= newValue && newValue < numberOfMenus, "Invalid selectedIndex: \(newValue)")
			setSelectedIndex(newValue, animated: false)
		}
	}
	
	private var isVisible: Bool { return (window != nil) }
	
	/// Observer hack
	private var observerRemoved: Bool = false
	
	// MARK: - Private
	private var numberOfMenus: Int {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuView(self)
	}
	
	public convenience init(scrollingOption: ScrollingOption) {
		self.init(frame: CGRectZero)
		self.scrollingOption = scrollingOption
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		// Layout
		menuCollectionViewLayout.scrollDirection = .Horizontal
		menuCollectionViewLayout.minimumLineSpacing = 0.0
		menuCollectionViewLayout.minimumInteritemSpacing = 0.0
		menuCollectionViewLayout.sectionInset = UIEdgeInsetsZero
		
		// Collection View
		menuCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: menuCollectionViewLayout)
		
		menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(menuCollectionView)
		
		menuCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell))
		
		menuCollectionView.backgroundColor = UIColor.clearColor()
		menuCollectionView.dataSource = self
		menuCollectionView.delegate = self
		
		menuCollectionView.scrollEnabled = scrollEnabled
		menuCollectionView.bounces = true
		menuCollectionView.alwaysBounceHorizontal = true
		menuCollectionView.alwaysBounceVertical = false
		menuCollectionView.directionalLockEnabled = true
		
		menuCollectionView.scrollsToTop = false
		menuCollectionView.showsHorizontalScrollIndicator = false
		menuCollectionView.showsVerticalScrollIndicator = false
		
		menuCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
		
		menuCollectionView.allowsMultipleSelection = false
		
		menuCollectionView.contentInset = UIEdgeInsetsZero
		
		// Observe contentSize to update contentOffset when menu is first shown
		menuCollectionView.addObserver(self, forKeyPath: "contentSize", options: [.New, .Old], context: nil)
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		var constraints = [NSLayoutConstraint]()
		
		if #available(iOS 9.0, *) {
		    constraints.append(menuCollectionView.topAnchor.constraintEqualToAnchor(self.topAnchor))
			constraints.append(menuCollectionView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor))
			constraints.append(menuCollectionView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor))
			constraints.append(menuCollectionView.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor))
		} else {
			constraints.append(NSLayoutConstraint(item: menuCollectionView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
			constraints.append(NSLayoutConstraint(item: menuCollectionView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
			constraints.append(NSLayoutConstraint(item: menuCollectionView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
			constraints.append(NSLayoutConstraint(item: menuCollectionView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
		}
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	deinit {
		if !observerRemoved {
			menuCollectionView.removeObserver(self, forKeyPath: "contentSize", context: nil)
		}
	}
	
	public func setSelectedIndex(index: Int, animated: Bool) {
		if _selectedIndex == index { return }
		_selectedIndex = index
//		switch scrollingOption {
//		case .None:
//		case .Leading:
//			menuCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 400, bottom: 0.0, right: 400)
//		case .Center:
//			
//		}
		if isVisible {
			menuCollectionView.setContentOffset(contentOffsetForIndex(index), animated: animated)
		}
		
		delegate?.menuView(self, didSelectIndex: index)
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		guard let change = change as? [String : NSValue] else { return }
		if object === menuCollectionView {
			guard let oldContentSize = change[NSKeyValueChangeOldKey]?.CGSizeValue() else { return }
			guard let newContentSize = change[NSKeyValueChangeNewKey]?.CGSizeValue() else { return }
			// If this is the first time size changed, which means view firstly appears
			if oldContentSize == CGSizeZero && newContentSize != CGSizeZero {
				// In this case, update content size
				menuCollectionView.setContentOffset(contentOffsetForIndex(selectedIndex), animated: false)
				if !observerRemoved {
					menuCollectionView.removeObserver(self, forKeyPath: "contentSize", context: nil)
					observerRemoved = true
				}
			}
		}
	}
}



// MARK: - UICollectionViewDataSource
extension MenuView : UICollectionViewDataSource {
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		checkForNegativeHeight(collectionView)
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfMenus
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UICollectionViewCell), forIndexPath: indexPath)

		cell.layoutMargins = UIEdgeInsetsZero
		cell.contentView.removeAllSubviews()
		cell.contentView.layoutMargins = UIEdgeInsetsZero
		
		guard let view = dataSource?.menuView(self, menuViewForIndex: indexPath.item, contentView: cell.contentView) else {
			fatalError("MenuView: dataSource is nil.")
		}
		
		if !cell.contentView.containSubview(view) {
			cell.contentView.addSubview(view)
		}
		
		return cell
	}
}



// MARK: - UICollectionViewDelegate
extension MenuView : UICollectionViewDelegate {
	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		setSelectedIndex(indexPath.item, animated: true)
	}
}



// MARK: - UICollectionViewDelegateFlowLayout
extension MenuView : UICollectionViewDelegateFlowLayout {
	public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let height = checkForNegativeHeight(collectionView)
		let width = menuWidthForIndex(indexPath.item)
		
		return CGSize(width: width, height: height)
	}
}



extension MenuView : UIScrollViewDelegate {
	public func scrollViewDidScroll(scrollView: UIScrollView) {
//		print("offset: \(scrollView.contentOffset.x)")
		delegate?.menuView(self, didScrollToOffset: scrollView.contentOffset.x)
	}
	
	public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//		print("scrollViewWillEndDragging: \(targetContentOffset.memory)")
//		print("velocity: \(velocity)")
		let closestIndex = closestIndexForOffsetX(targetContentOffset.memory.x)
//		print("index: \(closestIndex), offset: \(contentOffsetForIndex(closestIndex))")
		targetContentOffset.memory = contentOffsetForIndex(closestIndex)
		setSelectedIndex(closestIndex, animated: true)
	}
}



extension MenuView {
	public func scrollWithSelectedIndex(index: Int, withOffsetPercent percent: CGFloat = 0.0, animated: Bool = false) {
		let targetContentOffset = contentOffsetForIndex(index, offsetPercent: percent)
		menuCollectionView.setContentOffset(targetContentOffset, animated: animated)
	}
}



// MARK: - Helpers
extension MenuView {
	private func checkForNegativeHeight(collectionView: UICollectionView) -> CGFloat {
		let topInsetBottomInsetToMinus = menuCollectionView.contentInset.top + menuCollectionView.contentInset.bottom
		if collectionView.bounds.height == 0 {
			return 0.0
		}
		
		let height = collectionView.bounds.height - topInsetBottomInsetToMinus
		
		if height <= 0 {
			NSLog("collectionView's contentInset top + bottom is not zero, this results a non-positive menu view height")
			NSLog("The collectionView is \(collectionView)")
			NSLog("Are you leaving `automaticallyAdjustsScrollViewInsets` set to `true` in the view controller setting up the MenuView?")
		}
		
		return height
	}
	
	public func menuWidthForIndex(index: Int) -> CGFloat {
		// Expecting from delegate for width
		if let delegate = delegate {
			return delegate.menuView(self, menuWidthForIndex: index)
		}
		
		// If no delegate, use view width
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		
		return dataSource.menuView(self, menuViewForIndex: index, contentView: nil).bounds.width
	}
	
	public func contentOffsetForIndex(index: Int, offsetPercent: CGFloat = 0.0) -> CGPoint {
		precondition(0 <= index && index <= dataSource?.numberOfMenusInMenuView(self), "invalid index: \(index)")
		
		var targetOffsetX: CGFloat = 0.0
		var i = 0
		while i < index {
			targetOffsetX += menuWidthForIndex(i) + spacingsBetweenMenus
			i++
		}
		
		if offsetPercent < 0 {
			// -1.0 ... 0.0
			targetOffsetX += (menuWidthForIndex(max(index - 1, 0)) + spacingsBetweenMenus) * offsetPercent
		} else if offsetPercent > 0 {
			// 0.0 ... 1.0
			targetOffsetX += (menuWidthForIndex(index) + spacingsBetweenMenus) * offsetPercent
		}
		
		// This adjust half spacing between menu
		targetOffsetX -= spacingsBetweenMenus / 2.0
		
		switch scrollingOption {
		case .None: break
		case .Leading: break
		case .Center: targetOffsetX -= (bounds.width - menuWidthForIndex(index) - spacingsBetweenMenus) / 2.0
		}
		
		return CGPoint(x: targetOffsetX, y: 0)
	}
	
	public func closestIndexForOffsetX(var offsetX: CGFloat) -> Int {
		switch scrollingOption {
		case .None: break
		case .Leading: break
		case .Center:
			// FIXME: calculation is bad
			offsetX += (bounds.width - menuWidthForIndex(0)) / 2.0
		}
		
		var separatorPoint: CGFloat = 0.0
		var index = 0
		while index < numberOfMenus {
			if index == 0 {
				separatorPoint = menuWidthForIndex(index) / 2.0
			} else {
				separatorPoint += (menuWidthForIndex(index - 1) + menuWidthForIndex(index)) / 2.0 + spacingsBetweenMenus
			}
			
			if offsetX <= separatorPoint {
				return index
			}
			
			index++
		}
		
		return index - 1
	}
}
