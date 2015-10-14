//
//  MenuPageViewController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-02.
//
//

import UIKit

// TODO: Adopting delegates
public protocol MenuPageViewControllerDataSource: class {
	func numberOfMenusInMenuPageViewController(menuPageViewController: MenuPageViewController) -> Int
	func menuPageViewController(menuPageViewController: MenuPageViewController, menuViewForIndex index: Int) -> UIView
	func menuPageViewController(menuPageViewController: MenuPageViewController, viewControllerForIndex index: Int) -> UIViewController
}



public protocol MenuPageViewControllerDelegate: class {
	func menuPageViewController(menuPageViewController: MenuPageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController)
}



public class MenuPageViewController: UIViewController {
	
	// MARK: - Public
	public var menuTitleHeight: CGFloat = 44.0
	
	public weak var dataSource: MenuPageViewControllerDataSource?
	public weak var delegate: MenuPageViewControllerDelegate?
	
	// MARK: - Private
	private var numberOfMenus: Int {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuPageViewController(self)
	}
	
	private let menuView = MenuView()
	private let pageViewController = PageViewController()
		
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		//
	}
}



// MARK: - Override
extension MenuPageViewController {
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		
		setupViews()
	}
	
	private func setupViews() {
		// MenuView
		view.addSubview(menuView)
		
		// PageViewController
		addChildViewController(pageViewController)
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(pageViewController.view)
		pageViewController.didMoveToParentViewController(self)
		
		pageViewController.pageScrollView.delegate = self
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		view.layoutMargins = UIEdgeInsetsZero
		
		let views = ["menuView": menuView, "pageView": pageViewController.view]
		let metrics = ["menuTitleHeight": menuTitleHeight]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuView]|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[menuView(menuTitleHeight)][pageView]|", options: [.AlignAllLeading, .AlignAllTrailing], metrics: metrics, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		menuView.menuCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
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







// MARK: - UIScrollViewDelegate
extension MenuPageViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView === menuView.menuCollectionView {
			if scrollView.contentOffset.y != 0 {
				scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
			}
		}
		
		if scrollView === pageViewController.pageScrollView {
			print("scrollViewOffset: \(scrollView.contentOffset.x)")
			
			let menuOffset = menuView.menuCollectionView.contentOffset
			menuView.menuCollectionView.setContentOffset(CGPoint(x: menuOffset.x + 1, y: menuOffset.y), animated: false)
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
