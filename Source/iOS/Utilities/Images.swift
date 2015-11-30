//
//  Images.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-29.
//
//

import Foundation

extension UIImage {
	
	enum ImageAssets: String {
		case Camera = "Camera"
	}
	
	convenience init!(asset: ImageAssets) {
		self.init(named: asset.rawValue, inBundle: Resource.bundle, compatibleWithTraitCollection: nil)
	}
}
