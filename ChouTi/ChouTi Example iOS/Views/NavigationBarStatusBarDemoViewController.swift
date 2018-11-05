//
//  NavigationBarStatusBarDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-01-16.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import ChouTi
import UIKit

class NavigationBarStatusBarDemoViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.white
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		let statusBar = navigationController?.navigationBar.showStatusBarWithText("Hello, World!", animated: true, autoDismiss: true, displayingDuration: 2)
		statusBar?.backgroundColor = UIColor(red: 66 / 255.0, green: 173 / 255.0, blue: 212 / 255.0, alpha: 255 / 255.0)
		statusBar?.titleLabel.textColor = UIColor(red: 252 / 255.0, green: 186 / 255.0, blue: 2 / 255.0, alpha: 255 / 255.0)
		statusBar?.statusBarHeight = 30.0
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.navigationBar.dismissStatusBar(true)
	}
}
