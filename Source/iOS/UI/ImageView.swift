//
//  ImageView.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-08.
//
//

import UIKit

public class ImageView: UIImageView {
	public var rounded: Bool = false
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		if rounded {
			layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
		}
	}
}
