//
//  ImageView.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-08.
//
//

import UIKit

open class ImageView: UIImageView {
	open var rounded: Bool = false

	open override func layoutSubviews() {
		super.layoutSubviews()

		if rounded {
			layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
		}
	}
}
