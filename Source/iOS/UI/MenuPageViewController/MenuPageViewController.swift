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
	func numberOfMenusInMenuPageViewController(_ menuPageViewController: MenuPageViewController) -> Int
	func menuPageViewController(_ menuPageViewController: MenuPageViewController, menuViewForIndex index: Int, contentView: UIView?) -> UIView
	func menuPageViewController(_ menuPageViewController: MenuPageViewController, viewControllerForIndex index: Int) -> UIViewController
}



public protocol MenuPageViewControllerDelegate : class {
	func menuPageViewController(_ menuPageViewController: MenuPageViewController, menuWidthForIndex index: Int) -> CGFloat
	func menuPageViewController(_ menuPageViewController: MenuPageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController)
}



open class MenuPageViewController : UIViewController {
	
	// MARK: - Public
	open var menuTitleHeight: CGFloat = 44.0
	
	open let menuView = MenuView()
	open let pageViewController = PageViewController()
	
	fileprivate var _selectedIndex: Int = 0
	open var selectedIndex: Int {
		get { return _selectedIndex }
		set {
			let isValidIndex = (0 <= newValue && newValue < numberOfMenus)
			assert(isValidIndex, "Invalid selectedIndex: \(newValue)")
			if isValidIndex {
				setSelectedIndex(newValue, animated: false)
			}
		}
	}
	
	open weak var dataSource: MenuPageViewControllerDataSource?
	open weak var delegate: MenuPageViewControllerDelegate?
	
	// MARK: - Private
	fileprivate var numberOfMenus: Int {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuPageViewController(self)
	}
	
	fileprivate var isUpdatingSelectedIndex: Bool = false
		
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	fileprivate func commonInit() {
		menuView.dataSource = self
		menuView.delegate = self
		
		pageViewController.dataSource = self
		pageViewController.delegate = self
		
		automaticallyAdjustsScrollViewInsets = false
		
		menuView.spacingsBetweenMenus = 10.0
	}
	
	open func setSelectedIndex(_ index: Int, animated: Bool, completion: ((Bool) -> Void)? = nil) {
		if _selectedIndex == index { return }
		_selectedIndex = index
		
		isUpdatingSelectedIndex = true
		menuView.setSelectedIndex(index, animated: animated)
		pageViewController.setSelectedIndex(index, animated: animated, completion: completion)
		isUpdatingSelectedIndex = false
	}
	
	open func reload() {
		menuView.reload()
		pageViewController.reloadViewControllers()
	}
}



// MARK: - Override
extension MenuPageViewController {
	open override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		
		setupViews()
	}
	
	fileprivate func setupViews() {
		// MenuView
		menuView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(menuView)
		
		// PageViewController
		addChildViewController(pageViewController)
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(pageViewController.view)
		pageViewController.didMove(toParentViewController: self)
		
		pageViewController.pageScrollView.delegate = self
		
		setupConstraints()
	}
	
	fileprivate func setupConstraints() {
		view.layoutMargins = UIEdgeInsets.zero
		let views : [String : UIView] = [
			"menuView" : menuView,
			"pageView" : pageViewController.view
		]
		
		let metrics = [
			"menuTitleHeight" : menuTitleHeight
		]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuView]|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[menuView(menuTitleHeight)][pageView]|", options: [.alignAllLeading, .alignAllTrailing], metrics: metrics, views: views)
		
		NSLayoutConstraint.activate(constraints)
	}
	
//	public override func viewDidLayoutSubviews() {
//		super.viewDidLayoutSubviews()
//		print("viewDidLayoutSubviews")
//		setSelectedIndex(selectedIndex, animated: false)
//	}
}



extension MenuPageViewController {
	fileprivate func removeViewController(_ viewController: UIViewController) {
		viewController.willMove(toParentViewController: nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParentViewController()
	}
	
	fileprivate func addViewController(_ viewController: UIViewController) {
		addChildViewController(viewController)
		view.addSubview(viewController.view)
		viewController.didMove(toParentViewController: self)
	}
}



// MARK: - UIScrollViewDelegate
extension MenuPageViewController : UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView === menuView.menuCollectionView {
			if scrollView.contentOffset.y != 0 {
				scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
			}
		}
		
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewDidScroll(scrollView)
		}
	}
	
	public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewWillBeginDragging(scrollView)
		}
	}
	
	public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
		}
	}
	
	public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
		}
	}
	
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewDidEndDecelerating(scrollView)
		}
	}
	
	public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		if scrollView === pageViewController.pageScrollView {
			pageViewController.scrollViewDidEndScrollingAnimation(scrollView)
		}
	}
}



// MARK: - MenuViewDataSource
extension MenuPageViewController : MenuViewDataSource {
	public func numberOfMenusInMenuView(_ menuView: MenuView) -> Int {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuPageViewController(self)
	}
	
	public func menuView(_ menuView: MenuView, menuViewForIndex index: Int, contentView: UIView?) -> UIView {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.menuPageViewController(self, menuViewForIndex: index, contentView: contentView)
	}
}



// MARK: - MenuViewDelegate
extension MenuPageViewController : MenuViewDelegate {
	public func menuView(_ menuView: MenuView, menuWidthForIndex index: Int) -> CGFloat {
		// Expecting from delegate for width
		if let delegate = delegate {
			return delegate.menuPageViewController(self, menuWidthForIndex: index)
		}
		
		// If no delegate, use view width
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		
		let view = dataSource.menuPageViewController(self, menuViewForIndex: index, contentView: nil)
		return view.bounds.width
	}
	
	public func menuView(_ menuView: MenuView, didSelectIndex selectedIndex: Int) {
		// If selectedIndex updating is caused by selection of MenuPageVC, don't update pageVC
		if !isUpdatingSelectedIndex {
			_selectedIndex = selectedIndex
			pageViewController.setSelectedIndex(selectedIndex, animated: true, completion: nil)
		}
	}
	
	public func menuView(_ menuView: MenuView, didScrollToOffset offset: CGFloat) { }
}



// MARK: - PageViewControllerDataSource
extension MenuPageViewController : PageViewControllerDataSource {
	public func numberOfViewControllersInPageViewController(_ pageViewController: PageViewController) -> Int
	{
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.numberOfMenusInMenuPageViewController(self)
	}
	
	public func pageViewController(_ pageViewController: PageViewController, viewControllerForIndex index: Int) -> UIViewController {
		guard let dataSource = dataSource else { fatalError("dataSource is nil") }
		return dataSource.menuPageViewController(self, viewControllerForIndex: index)
	}
}



// MARK: - PageViewControllerDelegate
extension MenuPageViewController : PageViewControllerDelegate {
	public func pageViewController(_ pageViewController: PageViewController, didScrollWithSelectedIndex selectedIndex: Int, offsetPercent: CGFloat) {
		menuView.scrollWithSelectedIndex(pageViewController.selectedIndex, withOffsetPercent: offsetPercent)
	}
	
	public func pageViewController(_ pageViewController: PageViewController, didSelectIndex selectedIndex: Int, selectedViewController: UIViewController) {
		// If selectedIndex updating is caused by selection of MenuPageVC, don't update
		if !isUpdatingSelectedIndex {
			_selectedIndex = selectedIndex
			menuView.setSelectedIndex(selectedIndex, animated: true)
		}

		delegate?.menuPageViewController(self, didSelectIndex: selectedIndex, selectedViewController: selectedViewController)
	}
}
