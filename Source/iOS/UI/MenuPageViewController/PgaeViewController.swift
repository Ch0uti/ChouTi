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
	
	
	private var isDragging: Bool = false {
		didSet {
			print("dragging: \(isDragging)")
		}
	}
	
	
	private let pageScrollView = UIScrollView()
	
	private var beginDraggingContentOffsetX: CGFloat = 0.0 {
		didSet {
			beginDraggingContentOffsetX = CGFloat(Int(beginDraggingContentOffsetX) / Int(view.bounds.width)) * view.bounds.width
		}
	}
	
	private var willEndDraggingTargetContentOffset: CGFloat = 0.0
	
	private var draggingOffsetX: CGFloat { return pageScrollView.contentOffset.x - beginDraggingContentOffsetX }
	private var draggingForward: Bool? {
		if draggingOffsetX == 0 {
			return nil
		} else {
			return draggingOffsetX > 0
		}
	}
	
	private var scrollViewLastContentOffsetX: CGFloat?
	private var scrollViewMovingForward: Bool? {
		guard let scrollViewLastContentOffsetX = scrollViewLastContentOffsetX else {
			return nil
		}
		
		let offset = pageScrollView.contentOffset.x - scrollViewLastContentOffsetX
		if offset == 0 {
			return nil
		} else {
			return offset > 0
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
//		print("did scroll")
		if scrollView.contentOffset.y != 0 {
			scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
		}
		
		if !isDragging {
			let willSelectedIndex = Int(willEndDraggingTargetContentOffset) / Int(view.bounds.width)
			let willSelectedViewController = viewControllers[willSelectedIndex]
			
			if willSelectedViewController.isAppearing == nil {
				print("sssss")
				willSelectedViewController.beginAppearanceTransition(true, animated: true)
			}
			
			if selectedViewController.isAppearing == nil {
				print("sssss123")
				selectedViewController.beginAppearanceTransition(false, animated: true)
			}
			
			scrollViewLastContentOffsetX = scrollView.contentOffset.x
			return
		}
		
		// Zero offset
		guard let draggingForward = draggingForward else {
			print("dragging zero")
			if forwardViewController?.isAppearing != nil {
				forwardViewController?.beginAppearanceTransition(false, animated: false)
				forwardViewController?.endAppearanceTransition()
			}
			
			if backwardViewController?.isAppearing != nil {
				backwardViewController?.beginAppearanceTransition(false, animated: false)
				backwardViewController?.endAppearanceTransition()
			}
			
			scrollViewLastContentOffsetX = scrollView.contentOffset.x
			return
		}
		
		selectedViewController.beginAppearanceTransition(false, animated: true)
		
		if draggingForward {
			print("dragging forward")
			if backwardViewController?.isAppearing != nil {
				backwardViewController?.beginAppearanceTransition(false, animated: false)
				backwardViewController?.endAppearanceTransition()
			}
			
			forwardViewController?.beginAppearanceTransition(true, animated: true)
		} else {
			print("dragging backward")
			if forwardViewController?.isAppearing != nil {
				forwardViewController?.beginAppearanceTransition(false, animated: false)
				forwardViewController?.endAppearanceTransition()
			}
			
			backwardViewController?.beginAppearanceTransition(true, animated: true)
		}
		
		scrollViewLastContentOffsetX = scrollView.contentOffset.x
	}
	
	public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		print("willBegin dragging")
		// If when new dragging initiatied, last dragging is still in progress.
		// End appearance transition immediately
		// And set selectedIndex to willAppear view controller
		let appearingViewControllers = viewControllers.filter { $0.isAppearing == true }
		assert(appearingViewControllers.count <= 1)
		viewControllers.filter { $0.isAppearing != nil }.forEach { $0.endAppearanceTransition() }
		
		if let willAppearViewController = appearingViewControllers.first {
			selectedIndex = viewControllers.indexOf(willAppearViewController)!
		}
		
		isDragging = true
		beginDraggingContentOffsetX = scrollView.contentOffset.x
		print("offsetX: \(beginDraggingContentOffsetX)")
	}
	
	public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		isDragging = false
		print("target: \(targetContentOffset.memory.x)")
		willEndDraggingTargetContentOffset = targetContentOffset.memory.x
		if willEndDraggingTargetContentOffset == beginDraggingContentOffsetX {
			// Cancelled
			print("revert to initial state")
			selectedViewController.beginAppearanceTransition(true, animated: true)
			
			if forwardViewController?.isAppearing != nil {
				forwardViewController?.beginAppearanceTransition(false, animated: true)
			}
			
			if backwardViewController?.isAppearing != nil {
				backwardViewController?.beginAppearanceTransition(false, animated: true)
			}
		}
	}
	
	public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		// If dragging ends at separator point, clean state
		print("did end dragging, decelerate: \(decelerate)")
		if scrollView.contentOffset.x % view.bounds.width == 0 {
			print("called")
			viewControllers.filter { $0.isAppearing != nil }.forEach { $0.endAppearanceTransition() }
			selectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
		}
	}
	
	public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		print("end Decelerating")
		
		// If for some reasons, scrollView.contentOffset.x is not matched with willEndDraggingTargetContentOffset
		// End current transitions
		// Add missing transitions
		if willEndDraggingTargetContentOffset != scrollView.contentOffset.x {
			print("special case")
			let appearingViewControllers = viewControllers.filter { $0.isAppearing == true }
			assert(appearingViewControllers.count <= 1)
			
			// End current transitions
			viewControllers.filter { $0.isAppearing != nil }.forEach { $0.endAppearanceTransition() }
			
			if let willAppearViewController = appearingViewControllers.first {
				selectedIndex = viewControllers.indexOf(willAppearViewController)!
				
				// Add missing transitions
				selectedViewController.beginAppearanceTransition(false, animated: false)
				selectedViewController.endAppearanceTransition()
				
				let willSelectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
				print("willSelected: \(willSelectedIndex)")
				let willSelectedViewController = viewControllers[willSelectedIndex]
				willSelectedViewController.beginAppearanceTransition(true, animated: false)
				willSelectedViewController.endAppearanceTransition()
				selectedIndex = willSelectedIndex
			}
		} else {
			print("normal case")
			viewControllers.filter { $0.isAppearing != nil }.forEach { $0.endAppearanceTransition() }
			selectedIndex = Int(scrollView.contentOffset.x) / Int(view.bounds.width)
		}
		
		assert(viewControllers.filter { $0.isAppearing != nil }.count == 0)
	}
}

extension UIViewController {
	// AppearanceState Associated Property
	enum AppearanceState {
		case WillAppear
		case WillDisappear
	}
	
	private struct AssociatedKeys {
		static var AppearanceStateKey = "zhh_AppearanceStateKey"
	}
	
	var isAppearing: Bool? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.AppearanceStateKey) as? Bool
		}
		
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.AppearanceStateKey, newValue as Bool? as? AnyObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	// Swizzling beginAppearanceTransition/endAppearanceTransition
	public override class func initialize() {
		struct Static {
			static var beginAppearanceTransitionToken: dispatch_once_t = 0
			static var endAppearanceTransitionToken: dispatch_once_t = 0
		}
		
		// make sure this isn't a subclass
		if self !== UIViewController.self {
			return
		}
		
		dispatch_once(&Static.beginAppearanceTransitionToken) {
			let originalSelector = Selector("beginAppearanceTransition:animated:")
			let swizzledSelector = Selector("zhh_beginAppearanceTransition:animated:")
			
			let originalMethod = class_getInstanceMethod(self, originalSelector)
			let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
			
			let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
			
			if didAddMethod {
				class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
			} else {
				method_exchangeImplementations(originalMethod, swizzledMethod);
			}
		}
		
		dispatch_once(&Static.endAppearanceTransitionToken) {
			let originalSelector = Selector("endAppearanceTransition")
			let swizzledSelector = Selector("zhh_endAppearanceTransition")
			
			let originalMethod = class_getInstanceMethod(self, originalSelector)
			let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
			
			let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
			
			if didAddMethod {
				class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
			} else {
				method_exchangeImplementations(originalMethod, swizzledMethod);
			}
		}
	}
	
	func zhh_beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
		if self.isAppearing != isAppearing {
			self.zhh_beginAppearanceTransition(isAppearing, animated: animated)
			self.isAppearing = isAppearing
		}
	}
	
	func zhh_endAppearanceTransition() {
		self.zhh_endAppearanceTransition()
		self.isAppearing = nil
	}
}
