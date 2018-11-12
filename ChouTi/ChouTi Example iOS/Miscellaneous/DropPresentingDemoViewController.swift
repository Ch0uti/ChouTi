//
//  Created by Honghao Zhang on 12/03/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import ChouTi
import UIKit

class DropPresentingDemoViewController: UIViewController {

	let animator = DropPresentingAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor.white

		animator.animationDuration = 0.75
		animator.shouldDismissOnTappingOutsideView = true
		animator.presentingViewSize = CGSize(width: ceil(screenWidth * 0.7), height: 160)
		animator.overlayViewStyle = .normal(UIColor(white: 0.0, alpha: 0.85))

		let button = Button()
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)

		button.setBackgroundImageWithColor(UIColor.red, forState: .normal)
		button.setBackgroundImageWithColor(UIColor.red.withAlphaComponent(0.8), forState: .highlighted)
		button.setTitleColor(UIColor.white, for: .normal)
		button.setTitleColor(UIColor.white, for: .highlighted)

        button.setCornerRadius(.relative(percent: 0.3, attribute: .height), forState: .normal)

		button.setTitle("Present!", for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 22)

        button.constrainTo(size: CGSize(width: 160, height: 50))
		button.constrainToCenterInSuperview()

		button.addTarget(self, action: #selector(DropPresentingDemoViewController.buttonTapped(sender:)), for: .touchUpInside)
    }

	@objc
    func buttonTapped(sender: AnyObject) {
		let dummyViewController = UIViewController()
		dummyViewController.view.backgroundColor = UIColor(red: 255 / 255.0, green: 186 / 255.0, blue: 1 / 255.0, alpha: 255 / 255.0)
		dummyViewController.view.layer.cornerRadius = 8.0

        let button = Button()
        dummyViewController.view.addSubview(button)

        button.setBackgroundImageWithColor(UIColor(red: 0.31, green: 0.76, blue: 0.63, alpha: 1.00), forState: .normal)
        button.setBackgroundImageWithColor(UIColor(red: 0.31, green: 0.76, blue: 0.63, alpha: 1.00).withAlphaComponent(0.8), forState: .highlighted)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)

        button.setTitle("Dismiss", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)

        button.clipsToBounds = true
        button.layer.cornerRadius = 25

        button.addTarget(self, action: #selector(DropPresentingDemoViewController.dismiss(sender:)), for: .touchUpInside)

        button.constrainTo(size: CGSize(width: 120, height: 50))
        button.constrainToCenterInSuperview()

		dummyViewController.modalPresentationStyle = .custom
		dummyViewController.transitioningDelegate = animator

		present(dummyViewController, animated: true, completion: nil)
	}

    @objc
    func dismiss(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
