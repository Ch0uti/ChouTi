//
//  ImagePickerDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-11-29.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import ChouTi
import UIKit

@available(iOS 9.0, *)
class ImagePickerDemoViewController: UIViewController {

	let imagePickerView = ImagePickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = UIColor.white

		imagePickerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(imagePickerView)

        imagePickerView.clipsToBounds = true
        imagePickerView.layer.cornerRadius = 6.0

		imagePickerView.tintColor = UIColor.red

		let views = [
			"imagePickerView": imagePickerView
		]

		var constraints = [NSLayoutConstraint]()

		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[imagePickerView]-40-|", options: [], metrics: nil, views: views)
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-200-[imagePickerView(200)]", options: [], metrics: nil, views: views)

		NSLayoutConstraint.activate(constraints)
    }
}
