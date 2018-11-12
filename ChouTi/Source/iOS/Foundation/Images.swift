//
//  Images.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-11-29.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

extension UIImage {

	enum ImageAssets: String {
		case Camera
	}

	convenience init!(asset: ImageAssets) {
		self.init(named: asset.rawValue, in: Resource.bundle, compatibleWith: nil)
	}
}
