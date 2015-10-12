//
//  MenuPageViewController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-02.
//
//

import UIKit

// TODO: Adopting delegates
public protocol MenuPageViewControllerDataSource {
	func numberOfMenusInMenuPageViewController(menuPageViewController: MenuPageViewController) -> Int
	func menuPageViewController(menuPageViewController: MenuPageViewController, menuViewForIndex index: Int) -> UIView
	func menuPageViewController(menuPageViewController: MenuPageViewController, viewControllerForIndex index: Int) -> UIViewController
}

public protocol MenuPageViewControllerDelegate {
	func menuPageViewController(menuPageViewController: MenuPageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController)
}

public class MenuPageViewController: UIViewController {
	
	// MARK: - Public
	public var menuTitleHeight: CGFloat = 44.0
	
	// MARK: - Private
	private var numberOfMenus: Int = 0
	
	private let menuCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
	
	private let pageViewController = PageViewController()
	
    public override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		
		setupViews()
    }
	
	private func setupViews() {
		// menuCollectionView
		menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(menuCollectionView)
		
		MenuTitleCollectionViewCell.registerInCollectionView(menuCollectionView)
		
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
		
		// pageViewController
		addChildViewController(pageViewController)
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(pageViewController.view)
		pageViewController.didMoveToParentViewController(self)
		
		pageViewController.pageScrollView.delegate = self
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		view.layoutMargins = UIEdgeInsetsZero
		
		let views = ["menuCollectionView": menuCollectionView, "pageView": pageViewController.view]
		let metrics = ["menuTitleHeight": menuTitleHeight]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuCollectionView]|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[menuCollectionView(menuTitleHeight)][pageView]|", options: [.AlignAllLeading, .AlignAllTrailing], metrics: metrics, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		menuCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
	}
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
}



extension MenuPageViewController {
	private func removeViewController(viewController: UIViewController) {
		viewController.willMoveToParentViewController(nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParentViewController()
	}
	
	private func addViewController(viewController: UIViewController) {
		addChildViewController(viewController)
		view.addSubview(viewController.view)
		viewController.didMoveToParentViewController(self)
	}
}



// MARK: - UICollectionViewDataSource
extension MenuPageViewController: UICollectionViewDataSource {
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MenuTitleCollectionViewCell.identifier(), forIndexPath: indexPath) as! MenuTitleCollectionViewCell
		
		cell.titleLabel.text = "Test"
		
		return cell
	}
}



// MARK: - UICollectionViewDelegate
extension MenuPageViewController: UICollectionViewDelegate {
	
}



// MARK: - UIScrollViewDelegate
extension MenuPageViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView === menuCollectionView {
			if scrollView.contentOffset.y != 0 {
				scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
			}
		}
		
		if scrollView === pageViewController.pageScrollView {
			print("scrollViewOffset: \(scrollView.contentOffset.x)")
			
			let menuOffset = menuCollectionView.contentOffset
			menuCollectionView.setContentOffset(CGPoint(x: menuOffset.x + 1, y: menuOffset.y), animated: false)
			pageViewController.scrollViewDidScroll(scrollView)
		}
	}
	
	public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewWillBeginDragging(scrollView)
		}
	}
	
	public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
		}
	}
	
	public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
		}
	}
	
	public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewDidEndDecelerating(scrollView)
		}
	}
}
