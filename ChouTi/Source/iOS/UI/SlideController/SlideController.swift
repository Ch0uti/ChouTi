//
//  UIViewController+Utility.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-08-11.
//

import UIKit

// TODO: Handling rotations
/// SlideController provides an interface of left/right panel layout
open class SlideController: UIViewController {

	/// Center view controller
	open var centerViewController: UIViewController {
		willSet {
			beginViewController(centerViewController, appearanceTransition: false, animated: false)
			removeViewController(centerViewController)
			endViewControllerAppearanceTransition(centerViewController)
			if useScreenEdgePanGestureRecognizer {
				centerViewController.view.removeGestureRecognizer(leftEdgePanGestureRecognizer)
				centerViewController.view.removeGestureRecognizer(rightEdgePanGestureRecognizer)
			} else {
				centerViewController.view.removeGestureRecognizer(panGestureRecognizer)
			}
			centerViewController.view.removeGestureRecognizer(tapGestureRecognizer)
		}

		didSet {
			beginViewController(centerViewController, appearanceTransition: true, animated: false)
			addChild(centerViewController)

			// Make sure newly added center view is below status bar
			view.insertSubview(centerViewController.view, belowSubview: statusBarBackgroundView)

			// New view controller should have a same frame as before
			switch state {
			case .leftExpanding, .leftExpanded, .leftCollapsing:
				animateCenterViewControllerWithXOffset(leftRevealWidth ?? revealWidth, animated: false, completion: nil)
			case .rightExpanding, .rightExpanded, .rightCollapsing:
				animateCenterViewControllerWithXOffset(rightRevealWidth ?? revealWidth, animated: false, completion: nil)
			case .notExpanded:
				animateCenterViewControllerWithXOffset(0, animated: false, completion: nil)
			}

			// Make sure left/right view is below center view
			if let leftView = leftViewController?.view {
				view.insertSubview(leftView, belowSubview: centerViewController.view)
			}
			if let rightView = rightViewController?.view {
				view.insertSubview(rightView, belowSubview: centerViewController.view)
			}

			centerViewController.didMove(toParent: self)
			endViewControllerAppearanceTransition(centerViewController)

			if useScreenEdgePanGestureRecognizer {
				centerViewController.view.addGestureRecognizer(leftEdgePanGestureRecognizer)
				centerViewController.view.addGestureRecognizer(rightEdgePanGestureRecognizer)
			} else {
				centerViewController.view.addGestureRecognizer(panGestureRecognizer)
			}
			centerViewController.view.addGestureRecognizer(tapGestureRecognizer)
		}
	}

	/// Left view controller
	open var leftViewController: UIViewController? {
		willSet {
			switch state {
			case .leftExpanded, .leftExpanding, .leftCollapsing:
				beginViewController(leftViewController, appearanceTransition: false, animated: newValue == nil)
				previousLeftViewController = leftViewController
			default:
				break
			}

			if newValue == nil {
				animateLeftViewControllerShouldExpand(false, completion: { [unowned self] _ in
					if let leftViewController = self.previousLeftViewController {
						self.removeViewController(leftViewController)
						switch self.state {
						case .leftExpanded, .leftExpanding, .leftCollapsing:
							self.endViewControllerAppearanceTransition(leftViewController)
						default:
							break
						}

						self.previousLeftViewController = nil
					}
				})
			} else {
				if let leftViewController = self.leftViewController {
					removeViewController(leftViewController)
					endViewControllerAppearanceTransition(leftViewController)
				}

				previousLeftViewController = nil
			}
		}

		didSet {
			if state == .leftExpanded {
				beginViewController(leftViewController, appearanceTransition: true, animated: false)
				addViewController(leftViewController!)
				endViewControllerAppearanceTransition(leftViewController)
			}
		}
	}

	private var previousLeftViewController: UIViewController?

	/// Right view controller
	open var rightViewController: UIViewController? {
		willSet {
			switch state {
			case .rightExpanded, .rightExpanding, .rightCollapsing:
				beginViewController(rightViewController, appearanceTransition: false, animated: newValue == nil)
				previousRightViewController = rightViewController
			default:
				break
			}

			if newValue == nil {
				animateRightViewControllerShouldExpand(false, completion: { [unowned self] _ in
					if let rightViewController = self.previousRightViewController {
						self.removeViewController(rightViewController)
						switch self.state {
						case .rightExpanded, .rightExpanding, .rightCollapsing:
							self.endViewControllerAppearanceTransition(rightViewController)
						default:
							break
						}

						self.previousRightViewController = nil
					}
				})
			} else {
				if let rightViewController = self.rightViewController {
					removeViewController(rightViewController)
					endViewControllerAppearanceTransition(rightViewController)
				}

				previousRightViewController = nil
			}
		}

		didSet {
			if state == .rightExpanded {
				beginViewController(rightViewController, appearanceTransition: true, animated: false)
				addViewController(rightViewController!)
				endViewControllerAppearanceTransition(rightViewController)
			}
		}
	}

	private var previousRightViewController: UIViewController?

	/// Current showing state of slide controller
	public var state: SlideController.SlideState = .notExpanded {
		didSet {
			showShadowForCenterViewController(state != .notExpanded)
		}
	}

	/// Side view controller reveal width, by default, it's 3/4 of screen width
	open var revealWidth: CGFloat = 0.75 * UIScreen.main.bounds.width
	open var leftRevealWidth: CGFloat?
	open var rightRevealWidth: CGFloat?

	open var shouldExceedRevealWidth: Bool = true

	/// Reveal animation duration
	open var animationDuration: TimeInterval = 0.25
	private var animated: Bool { return animationDuration > 0.0 }

	/// Initial spring velocity of animation
	open var initialSpringVelocity: CGFloat?

	/// Spring dampin value of animation
	open var springDampin: CGFloat?

	var leftViewControllerAdded: Bool = false
	var rightViewControllerAdded: Bool = false

	var isAnimating: Bool = false

	/// Whether should use screen edge pan gesture
	open var useScreenEdgePanGestureRecognizer: Bool = true {
		didSet {
			if useScreenEdgePanGestureRecognizer {
				centerViewController.view.removeGestureRecognizer(panGestureRecognizer)
				centerViewController.view.addGestureRecognizer(leftEdgePanGestureRecognizer)
				centerViewController.view.addGestureRecognizer(rightEdgePanGestureRecognizer)
			} else {
				centerViewController.view.removeGestureRecognizer(leftEdgePanGestureRecognizer)
				centerViewController.view.removeGestureRecognizer(rightEdgePanGestureRecognizer)
				centerViewController.view.addGestureRecognizer(panGestureRecognizer)
			}
		}
	}

	let panGestureRecognizer = UIPanGestureRecognizer()
	let leftEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
	let rightEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
	let tapGestureRecognizer = UITapGestureRecognizer()

	/// Status bar color when expanded, set nil to clear status bar background color
	open var statusBarBackgroundColor: UIColor? = nil {
		didSet {
			if statusBarBackgroundColor == nil {
				statusBarBackgroundView.removeFromSuperview()
			} else {
				statusBarBackgroundView.backgroundColor = statusBarBackgroundColor
				view.addSubview(statusBarBackgroundView)
			}
		}
	}

	lazy var statusBarBackgroundView: UIView = {
        UIView(frame: UIApplication.shared.statusBarFrame)
	}()

    /// Initialize a SlideController with center, left and right view controller
    ///
    /// - Parameters:
    ///   - centerViewController: The center view controller
    ///   - leftViewController: The left view controller
    ///   - rightViewController: The right view controller
	public init(centerViewController: UIViewController, leftViewController: UIViewController?, rightViewController: UIViewController?) {
		self.centerViewController = centerViewController

		super.init(nibName: nil, bundle: nil)

		self.leftViewController = leftViewController
		self.rightViewController = rightViewController
	}

    @available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override open var shouldAutomaticallyForwardAppearanceMethods: Bool {
		return false
	}

	override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		switch state {
		case .leftExpanded, .leftExpanding, .leftCollapsing:
			leftViewController?.beginAppearanceTransition(true, animated: animated)
		case .rightExpanded, .rightExpanding, .rightCollapsing:
			rightViewController?.beginAppearanceTransition(true, animated: animated)
		case .notExpanded:
			break
		}
		centerViewController.beginAppearanceTransition(true, animated: animated)
	}

	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		switch state {
		case .leftExpanded, .leftExpanding, .leftCollapsing:
			leftViewController?.endAppearanceTransition()
		case .rightExpanded, .rightExpanding, .rightCollapsing:
			rightViewController?.endAppearanceTransition()
		case .notExpanded:
			break
		}
		centerViewController.endAppearanceTransition()
	}

	override open func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		super.viewWillAppear(animated)
		switch state {
		case .leftExpanded, .leftExpanding, .leftCollapsing:
			leftViewController?.beginAppearanceTransition(false, animated: animated)
		case .rightExpanded, .rightExpanding, .rightCollapsing:
			rightViewController?.beginAppearanceTransition(false, animated: animated)
		case .notExpanded:
			break
		}
		centerViewController.beginAppearanceTransition(false, animated: animated)
	}

	override open func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		switch state {
		case .leftExpanded, .leftExpanding, .leftCollapsing:
			leftViewController?.endAppearanceTransition()
		case .rightExpanded, .rightExpanding, .rightCollapsing:
			rightViewController?.endAppearanceTransition()
		case .notExpanded:
			break
		}
		centerViewController.endAppearanceTransition()
	}

	override open func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white

		panGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		leftEdgePanGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		leftEdgePanGestureRecognizer.edges = .left
		leftEdgePanGestureRecognizer.cancelsTouchesInView = false
		rightEdgePanGestureRecognizer.addTarget(self, action: #selector(SlideController.handlePanGesture(_:)))
		rightEdgePanGestureRecognizer.edges = .right
		rightEdgePanGestureRecognizer.cancelsTouchesInView = false
		tapGestureRecognizer.addTarget(self, action: #selector(SlideController.handleTapGesture(_:)))
		tapGestureRecognizer.cancelsTouchesInView = false

		panGestureRecognizer.delegate = self
		leftEdgePanGestureRecognizer.delegate = self
		rightEdgePanGestureRecognizer.delegate = self
		tapGestureRecognizer.delegate = self

		addChild(centerViewController)
		view.addSubview(centerViewController.view)
		centerViewController.didMove(toParent: self)

		if useScreenEdgePanGestureRecognizer {
			centerViewController.view.addGestureRecognizer(leftEdgePanGestureRecognizer)
			centerViewController.view.addGestureRecognizer(rightEdgePanGestureRecognizer)
		} else {
			centerViewController.view.addGestureRecognizer(panGestureRecognizer)
		}
		centerViewController.view.addGestureRecognizer(tapGestureRecognizer)

		if statusBarBackgroundColor != nil {
			statusBarBackgroundView.backgroundColor = statusBarBackgroundColor!.withAlphaComponent(0.0)
			view.addSubview(statusBarBackgroundView)
		}
	}
}

extension SlideController {
    /// Collapse slide controller, center view controller will be shown
	public func collapse() {
		switch state {
		case .leftExpanded:
			toggleLeftViewController()
		case .rightExpanded:
			toggleRightViewController()
		default:
			return
		}
	}

    /// Toggle left view controller
	public func toggleLeftViewController() {
		if leftViewController == nil {
            return
        }
		if isAnimating {
            return
        }
		let leftViewControllerShouldExapnd = (state != .leftExpanded)
		if leftViewControllerShouldExapnd {
			beginViewController(leftViewController, appearanceTransition: true, animated: animated)
			beginViewController(centerViewController, appearanceTransition: false, animated: animated)
		} else {
			beginViewController(leftViewController, appearanceTransition: false, animated: animated)
			beginViewController(centerViewController, appearanceTransition: true, animated: animated)
		}

		animateLeftViewControllerShouldExpand(leftViewControllerShouldExapnd) { [unowned self] _ in
			self.endViewControllerAppearanceTransition(self.leftViewController)
			self.endViewControllerAppearanceTransition(self.centerViewController)
			self.isAnimating = false
		}
	}

    /// Toggle right view controller
	public func toggleRightViewController() {
		if rightViewController == nil {
            return
        }
		if isAnimating {
            return
        }
		let rightViewControllerShouldExapnd = (state != .rightExpanded)
		if rightViewControllerShouldExapnd {
			beginViewController(rightViewController, appearanceTransition: true, animated: animated)
			beginViewController(centerViewController, appearanceTransition: false, animated: animated)
		} else {
			beginViewController(rightViewController, appearanceTransition: false, animated: animated)
			beginViewController(centerViewController, appearanceTransition: true, animated: animated)
		}

		animateRightViewControllerShouldExpand(rightViewControllerShouldExapnd) { [unowned self] _ in
			self.endViewControllerAppearanceTransition(self.rightViewController)
			self.endViewControllerAppearanceTransition(self.centerViewController)
		}
	}

	func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
		if shouldShowShadow {
			centerViewController.view.layer.shadowOpacity = 0.5
		} else {
			centerViewController.view.layer.shadowOpacity = 0.0
		}
	}

	func replaceViewController(_ viewController: UIViewController?, withViewController: UIViewController?) {
		if let viewController = viewController, children.contains(viewController) {
			removeViewController(viewController)
		}

		if let withViewController = withViewController, !children.contains(withViewController) {
			addViewController(withViewController)
		}
	}

	func removeViewController(_ viewController: UIViewController) {
		viewController.willMove(toParent: nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParent()
	}

	private func addViewController(_ viewController: UIViewController) {
		addChild(viewController)
		view.insertSubview(viewController.view, belowSubview: centerViewController.view)
	}
}

extension SlideController {
    func beginViewController(_ viewController: UIViewController?, appearanceTransition isAppearing: Bool, animated: Bool) {
		if isVisible {
			viewController?.beginAppearanceTransition(isAppearing, animated: animated)
		}
	}

	func endViewControllerAppearanceTransition(_ viewController: UIViewController?) {
		if isVisible {
			viewController?.endAppearanceTransition()
		}
	}
}
