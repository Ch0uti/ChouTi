//
//  CIImageFilter.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-11.
//
//

import UIKit
import QuartzCore

open class CIImageFilter {
	public typealias Filter = (CIImage) -> CIImage?
	
	open class func gaussianBlur(_ radius: Double) -> Filter {
		return { image in
			let parameters = [
				kCIInputRadiusKey : radius,
				kCIInputImageKey : image
			] as [String : Any]
			
			let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters)
			return filter?.outputImage
		}
	}
	
	open class func constantColorGenerator(_ color: UIColor) -> Filter {
		return { _ in
			let parameters = [kCIInputColorKey: CIColor(color: color)]
			let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
			return filter?.outputImage
		}
	}

	open class func sourceOverCompositing(_ overlayImage: CIImage) -> Filter {
		return { image in
			let parameters = [
				kCIInputImageKey : overlayImage,
				kCIInputBackgroundImageKey : image
			]
			let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters)
			let cropRect = image.extent
			return filter?.outputImage?.cropping(to: cropRect)
		}
	}
	
	open class func colorOverlay(_ color: UIColor) -> Filter {
		return { image in
			if let overlay = constantColorGenerator(color)(image) {
				return sourceOverCompositing(overlay)(image)
			} else {
				return nil
			}
		}
	}
}

public typealias Filter = CIImageFilter.Filter

infix operator >>> : AdditionPrecedence
public func >>> (filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
	return { image in
		if let imageAfterFilter1 = filter1(image) {
			return filter2(imageAfterFilter1)
		} else {
			return nil
		}
	}
}
