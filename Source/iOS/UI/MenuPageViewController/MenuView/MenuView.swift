//
//  MenuView.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-11.
//
//

import UIKit

public protocol MenuViewDataSource: class {
	func numberOfMenusInMenuView(menuView: MenuView) -> Int
	func menuView(menuView: MenuView, menuViewForIndex index: Int) -> UIView
	func menuView(menuView: MenuView, menuWidthForIndex index: Int) -> CGFloat
}



public protocol MenuViewDelegate: class {
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
		menuCollectionViewLayout.minimumInteritemSpacing = 0.0
		
		// Collection View
		menuCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: menuCollectionViewLayout)
		
		menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(menuCollectionView)
		
		menuCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell))
		
		menuCollectionView.backgroundColor = UIColor.whiteColor()
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
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfMenus
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UICollectionViewCell), forIndexPath: indexPath)
		
		guard let view = dataSource?.menuView(self, menuViewForIndex: indexPath.item) else {
			fatalError("MenuView: dataSource is nil.")
		}
		
		cell.contentView.addSubview(view)
		
		return cell
	}
}



// MARK: - UICollectionViewDelegate
extension MenuView : UICollectionViewDelegate {
	
}
