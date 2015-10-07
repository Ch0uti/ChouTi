//
//  PgaeViewController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-05.
//
//

import UIKit

public class PageViewController: UIViewController {
	public var selectedIndex: Int = 0 {
		didSet {
			print("selected: \(selectedIndex)")
		}
	}
	public var selectedViewController: UIViewController {
		return viewControllers[selectedIndex]
	}
	
	public var viewControllers = [UIViewController]() {
		willSet {
			willReplaceOldViewControllers(viewControllers, withNewViewControllers: newValue)
			setupChildViewControllerViews(newValue)
		}
		didSet {
			didReplaceOldViewControllers(oldValue, withNewViewControllers: viewControllers)
		}
	}
	
	private var forwardViewController: UIViewController? {
		if selectedIndex + 1 < viewControllers.count {
			return viewControllers[selectedIndex + 1]
		} else {
			return nil
		}
	}
	
	private var backwardViewController: UIViewController? {
		if selectedIndex - 1 >= 0 {
			return viewControllers[selectedIndex - 1]
		} else {
			return nil
		}
	}
	
	private var forwardAppearanceCalled: Bool = false
	private var backwardAppearanceCalled: Bool = false
	
	private var isDragging: Bool = false {
		didSet {
			print("dragging: \(isDragging)")
		}
	}
	
	private var appearanceCalledViewControllers = Set<UIViewController>()
	private var willAppearViewController: UIViewController?
	private var willDisappearViewController: UIViewController?
	
	private let pageScrollView = UIScrollView()
	
	private var beginDraggingContentOffsetX: CGFloat = 0.0 {
		didSet {
			beginDraggingContentOffsetX = CGFloat(Int(beginDraggingContentOffsetX) / Int(view.bounds.width)) * view.bounds.width
		}
	}
	private var draggingOffsetX: CGFloat { return pageScrollView.contentOffset.x - beginDraggingContentOffsetX }
	private var draggingForward: Bool? {
		if draggingOffsetX == 0 {
			return nil
		} else if draggingOffsetX < 0 {
			return false
		} else {
			return true
		}
	}
	
	public override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
		return false
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		
		setupViews()
	}
	
	private func setupViews() {
		view.addSubview(pageScrollView)
		pageScrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
		pageScrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		pageScrollView.delegate = self
		
		pageScrollView.pagingEnabled = true
		pageScrollView.scrollEnabled = true
		pageScrollView.bounces = true
		pageScrollView.alwaysBounceHorizontal = true
		pageScrollView.alwaysBounceVertical = false
		pageScrollView.directionalLockEnabled = true
		pageScrollView.scrollsToTop = false
		pageScrollView.showsHorizontalScrollIndicator = false
		pageScrollView.showsVerticalScrollIndicator = false
		
		pageScrollView.contentInset = UIEdgeInsetsZero
		automaticallyAdjustsScrollViewInsets = false
	}
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	private func willReplaceOldViewControllers(oldViewControllers: [UIViewController], withNewViewControllers newViewControllers: [UIViewController]) {
		for viewController in oldViewControllers {
			removeViewController(viewController)
		}
		
		for viewController in newViewControllers {
			addViewController(viewController)
		}
	}
	
	private func didReplaceOldViewControllers(oldViewControllers: [UIViewController], withNewViewControllers newViewControllers: [UIViewController]) {
		//
	}
	
	private func setupChildViewControllerViews(viewControllers: [UIViewController]) {
		// TODO: layoutSubviews may need to update contentSize
		pageScrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(viewControllers.count), height: view.bounds.height)
		for (index, viewController) in viewControllers.enumerate() {
			viewController.view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
		}
	}
}

extension PageViewController {
	private func removeViewController(viewController: UIViewController) {
		viewController.willMoveToParentViewController(nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParentViewController()
	}
	
	private func addViewController(viewController: UIViewController) {
		addChildViewController(viewController)
		pageScrollView.addSubview(viewController.view)
		viewController.didMoveToParentViewController(self)
	}
}

// MARK: - UIScrollViewDelegate
extension PageViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y != 0 {
			scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
		}
		
		// Zero offset
		guard let draggingForward = draggingForward else {
			print("dragging zero")
			if isDragging {
				if forwardAppearanceCalled {
					if let forwardViewController = forwardViewController where appearanceCalledViewControllers.contains(forwardViewController) {
						forwardViewController.beginAppearanceTransition(false, animated: false)
						forwardViewController.endAppearanceTransition()
						appearanceCalledViewControllers.remove(forwardViewController)
					}
				}
				
				if backwardAppearanceCalled {
					if let backwardViewController = backwardViewController where appearanceCalledViewControllers.contains(backwardViewController) {
						backwardViewController.beginAppearanceTransition(false, animated: false)
						backwardViewController.endAppearanceTransition()
						appearanceCalledViewControllers.remove(backwardViewController)
					}
				}
			}
			
			return
		}
		
		if draggingForward {
			print("dragging forward")
			if backwardAppearanceCalled {
				if let backwardViewController = backwardViewController where appearanceCalledViewControllers.contains(backwardViewController) {
					backwardViewController.beginAppearanceTransition(false, animated: false)
					backwardViewController.endAppearanceTransition()
					appearanceCalledViewControllers.remove(backwardViewController)
				}
				
				backwardAppearanceCalled = false
			}
			
			if !forwardAppearanceCalled {
				if !appearanceCalledViewControllers.contains(selectedViewController) {
					selectedViewController.beginAppearanceTransition(false, animated: true)
					selectedViewController.appearanceState = .WillDisappear
					appearanceCalledViewControllers.insert(selectedViewController)
					willDisappearViewController = selectedViewController
				}
				
				if let forwardViewController = forwardViewController where !appearanceCalledViewControllers.contains(forwardViewController) {
					forwardViewController.beginAppearanceTransition(true, animated: true)
					appearanceCalledViewControllers.insert(forwardViewController)
					willAppearViewController = forwardViewController
				}
				
				forwardAppearanceCalled = true
			}
		} else {
			print("dragging backward")
			if forwardAppearanceCalled {
				if let forwardViewController = forwardViewController where appearanceCalledViewControllers.contains(forwardViewController) {
					forwardViewController.beginAppearanceTransition(false, animated: false)
					forwardViewController.endAppearanceTransition()
					appearanceCalledViewControllers.remove(forwardViewController)
				}
				
				forwardAppearanceCalled = false
			}
			
			if !backwardAppearanceCalled {
				if !appearanceCalledViewControllers.contains(selectedViewController) {
					selectedViewController.beginAppearanceTransition(false, animated: true)
					appearanceCalledViewControllers.insert(selectedViewController)
					willDisappearViewController = selectedViewController
				}
				if let backwardViewController = backwardViewController where !appearanceCalledViewControllers.contains(backwardViewController) {
					backwardViewController.beginAppearanceTransition(true, animated: true)
					appearanceCalledViewControllers.insert(backwardViewController)
					willAppearViewController = backwardViewController
				}
				
				backwardAppearanceCalled = true
			}
		}
	}
	
	public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		appearanceCalledViewControllers.forEach { $0.endAppearanceTransition() }
		appearanceCalledViewControllers.removeAll()
		forwardAppearanceCalled = false
		backwardAppearanceCalled = false
		if let willAppearViewController = willAppearViewController {
			selectedIndex = viewControllers.indexOf(willAppearViewController)!
		}
		willAppearViewController = nil
		willDisappearViewController = nil
		
		isDragging = true
		beginDraggingContentOffsetX = scrollView.contentOffset.x
		print("offsetX: \(beginDraggingContentOffsetX)")
	}
	
	public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		isDragging = false
		print("target: \(targetContentOffset.memory.x)")
		if targetContentOffset.memory.x == beginDraggingContentOffsetX {
			// Cancelled
			if appearanceCalledViewControllers.contains(selectedViewController) {
				selectedViewController.beginAppearanceTransition(true, animated: true)
				willAppearViewController = selectedViewController
			}
			
			if let forwardViewController = forwardViewController where appearanceCalledViewControllers.contains(forwardViewController) {
				forwardViewController.beginAppearanceTransition(false, animated: true)
				willDisappearViewController = forwardViewController
			}
			
			if let backwardViewController = backwardViewController where appearanceCalledViewControllers.contains(backwardViewController) {
				backwardViewController.beginAppearanceTransition(false, animated: true)
				willDisappearViewController = backwardViewController
			}
		}
	}
	
	public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		// If dragging ends at separator point, clean state
		if scrollView.contentOffset.x % view.bounds.width == 0 {
			appearanceCalledViewControllers.forEach { $0.endAppearanceTransition() }
			appearanceCalledViewControllers.removeAll()
			forwardAppearanceCalled = false
			backwardAppearanceCalled = false
			willAppearViewController = nil
			willDisappearViewController = nil
			selectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
		}
	}
	
	public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		print("end Decel")
		appearanceCalledViewControllers.forEach { $0.endAppearanceTransition() }
		appearanceCalledViewControllers.removeAll()
		forwardAppearanceCalled = false
		backwardAppearanceCalled = false
		willAppearViewController = nil
		willDisappearViewController = nil
		
		selectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
	}
}

extension UIViewController {
	enum AppearanceState {
		case WillAppear
		case WillDisappear
		case End
	}
	
	private struct AssociatedKeys {
		static var AppearanceStateKey = "zhh_AppearanceStateKey"
	}
	
	var appearanceState: AppearanceState? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.AppearanceStateKey) as? AppearanceState
		}
		
		set {
			if let newValue = newValue {
				objc_setAssociatedObject(self, &AssociatedKeys.AppearanceStateKey, newValue as AppearanceState? as? AnyObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
		}
	}
}
