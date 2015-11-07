//
//  MenuPageViewController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-02.
//
//

import UIKit

// TODO: Adopting delegates
public protocol MenuPageViewControllerDataSource : class {
	func numberOfMenusInMenuPageViewController(menuPageViewController: MenuPageViewController) -> Int
	func menuPageViewController(menuPageViewController: MenuPageViewController, menuViewForIndex index: Int, contentView: UIView?) -> UIView
	func menuPageViewController(menuPageViewController: MenuPageViewController, viewControllerForIndex index: Int) -> UIViewController
}



public protocol MenuPageViewControllerDelegate : class {
	func menuPageViewController(menuPageViewController: MenuPageViewController, menuWidthForIndex index: Int) -> CGFloat
	func menuPageViewController(menuPageViewController: MenuPageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController)
}



public class MenuPageViewController : UIViewController {
	
	// MARK: - Public
	public var menuTitleHeight: CGFloat = 44.0
	
	public let menuView = MenuView()
	public let pageViewController = PageViewController()
	
	private var _selectedIndex: Int = 0
	public var selectedIndex: Int {
		get { return _selectedIndex }
		set {
			let isValidIndex = (0 <= newValue && newValue < numberOfMenus)
			assert(isValidIndex, "Invalid selectedIndex: \(newValue)")
			if isValidIndex {
				setSelectedIndex(newValue, animated: false)
			}
		}
	}
	
	public weak var dataSource: MenuPageViewControllerDataSource?
	public weak var delegate: MenuPageViewControllerDelegate?
	
	// MARK: - Private
	private var numberOfMenus: Int {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuPageViewController(self)
	}
	
	private var isUpdatingSelectedIndex: Bool = false
		
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		menuView.dataSource = self
		menuView.delegate = self
		
		pageViewController.dataSource = self
		pageViewController.delegate = self
		
		automaticallyAdjustsScrollViewInsets = false
		
		menuView.spacingsBetweenMenus = 10.0
	}
	
	public func setSelectedIndex(index: Int, animated: Bool, completion: (Bool -> Void)? = nil) {
		if _selectedIndex == index { return }
		_selectedIndex = index
		
		isUpdatingSelectedIndex = true
		menuView.setSelectedIndex(index, animated: animated)
		pageViewController.setSelectedIndex(index, animated: animated, completion: completion)
		isUpdatingSelectedIndex = false
	}
	
	public func reload() {
		menuView.reload()
		pageViewController.reloadViewControllers()
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
		menuView.translatesAutoresizingMaskIntoConstraints = false
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
	
//	public override func viewDidLayoutSubviews() {
//		super.viewDidLayoutSubviews()
//		print("viewDidLayoutSubviews")
//		setSelectedIndex(selectedIndex, animated: false)
//	}
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
extension MenuPageViewController : UIScrollViewDelegate {
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView === menuView.menuCollectionView {
			if scrollView.contentOffset.y != 0 {
				scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
			}
		}
		
		if scrollView === pageViewController.pageScrollView {
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
	
	public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewDidEndScrollingAnimation(scrollView)
		}
	}
}



// MARK: - MenuViewDataSource
extension MenuPageViewController : MenuViewDataSource {
	public func numberOfMenusInMenuView(menuView: MenuView) -> Int {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuPageViewController(self)
	}
	
	public func menuView(menuView: MenuView, menuViewForIndex index: Int, contentView: UIView?) -> UIView {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.menuPageViewController(self, menuViewForIndex: index, contentView: contentView)
	}
}



// MARK: - MenuViewDelegate
extension MenuPageViewController : MenuViewDelegate {
	public func menuView(menuView: MenuView, menuWidthForIndex index: Int) -> CGFloat {
		// Expecting from delegate for width
		if let delegate = delegate {
			return delegate.menuPageViewController(self, menuWidthForIndex: index)
		}
		
		// If no delegate, use view width
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		
		let view = dataSource.menuPageViewController(self, menuViewForIndex: index, contentView: nil)
		return view.bounds.width
	}
	
	public func menuView(menuView: MenuView, didSelectIndex selectedIndex: Int) {
		// If selectedIndex updating is caused by selection of MenuPageVC, don't update pageVC
		if !isUpdatingSelectedIndex {
			_selectedIndex = selectedIndex
			pageViewController.setSelectedIndex(selectedIndex, animated: true, completion: nil)
		}
	}
	
	public func menuView(menuView: MenuView, didScrollToOffset offset: CGFloat) { }
}



// MARK: - PageViewControllerDataSource
extension MenuPageViewController : PageViewControllerDataSource {
	public func numberOfViewControllersInPageViewController(pageViewController: PageViewController) -> Int
	{
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuPageViewController(self)
	}
	
	public func pageViewController(pageViewController: PageViewController, viewControllerForIndex index: Int) -> UIViewController {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.menuPageViewController(self, viewControllerForIndex: index)
	}
}



// MARK: - PageViewControllerDelegate
extension MenuPageViewController : PageViewControllerDelegate {
	public func pageViewController(pageViewController: PageViewController, didScrollWithSelectedIndex selectedIndex: Int, offsetPercent: CGFloat) {
		menuView.scrollWithSelectedIndex(pageViewController.selectedIndex, withOffsetPercent: offsetPercent)
	}
	
	public func pageViewController(pageViewController: PageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController) {
		// If selectedIndex updating is caused by selection of MenuPageVC, don't update
		if !isUpdatingSelectedIndex {
			_selectedIndex = selectedIndex
			menuView.setSelectedIndex(selectedIndex, animated: true)
		}

		delegate?.menuPageViewController(self, didSelectIndex: selectedIndex, selectedViewController: selectedViewController)
	}
}
