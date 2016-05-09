//
//  ImagePickerDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-11-29.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

@available(iOS 9.0, *)
class ImagePickerDemoViewController: UIViewController {

	let imagePickerView = ImagePickerView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.whiteColor()
		
		imagePickerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(imagePickerView)
        
        imagePickerView.clipsToBounds = true
        imagePickerView.layer.cornerRadius = 6.0
		
		imagePickerView.tintColor = UIColor.redColor()
        
		let views = [
			"imagePickerView" : imagePickerView
		]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[imagePickerView]-40-|", options: [], metrics: nil, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-200-[imagePickerView(200)]", options: [], metrics: nil, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
    }
}
