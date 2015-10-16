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
	
	func menuView(menuView: MenuView, didSelectIndex selectedIndex: Int)
}



public class MenuView : UIView {
	// MARK: - Enums
	enum ScollingOption {
		case InBounds
		case Center
	}
	
	// MARK: - Public
	public var menuCollectionView: UICollectionView!
	public let menuCollectionViewLayout = UICollectionViewFlowLayout()
	
	public var spacingsBetweenMenus: CGFloat {
		get { return menuCollectionViewLayout.minimumLineSpacing }
		set { menuCollectionViewLayout.minimumLineSpacing = newValue }
	}
	
	public weak var dataSource: MenuViewDataSource?
	public weak var delegate: MenuViewDelegate?
	
	// MARK: - Private
	private var numberOfMenus: Int {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuView(self)
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
		
		menuCollectionView.scrollEnabled = true
		menuCollectionView.bounces = true
		menuCollectionView.alwaysBounceHorizontal = true
		menuCollectionView.alwaysBounceVertical = false
		menuCollectionView.directionalLockEnabled = true
		
		menuCollectionView.scrollsToTop = false
		menuCollectionView.showsHorizontalScrollIndicator = false
		menuCollectionView.showsVerticalScrollIndicator = false
		
		menuCollectionView.allowsMultipleSelection = false
		
		menuCollectionView.contentInset = UIEdgeInsetsZero
		
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
	
}



extension MenuView : UICollectionViewDelegateFlowLayout {
	public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let height = checkForNegativeHeight(collectionView)
		// Expecting from delegate for width
		if let delegate = delegate {
			return CGSize(width: delegate.menuView(self, menuWidthForIndex: indexPath.item), height: height)
		}
		
		// If no delegate, use view width
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		
		let view = dataSource.menuView(self, menuViewForIndex: indexPath.item, contentView: nil)
		return CGSize(width: view.bounds.width, height: height)
	}
}



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
}
