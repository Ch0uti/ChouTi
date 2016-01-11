//
//  CIImageFilter.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-01-11.
//
//

import UIKit
import QuartzCore

public class CIImageFilter {
	public typealias Filter = CIImage -> CIImage?
	
	public class func gaussianBlur(radius: Double) -> Filter {
		return { image in
			let parameters = [
				kCIInputRadiusKey : radius,
				kCIInputImageKey : image
			]
			
			let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters)
			return filter?.outputImage
		}
	}
	
	public class func constantColorGenerator(color: UIColor) -> Filter {
		return { _ in
			let parameters = [kCIInputColorKey: CIColor(color: color)]
			let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
			return filter?.outputImage
		}
	}

	public class func sourceOverCompositing(overlayImage: CIImage) -> Filter {
		return { image in
			let parameters = [
				kCIInputImageKey : overlayImage,
				kCIInputBackgroundImageKey : image
			]
			let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters)
			let cropRect = image.extent
			return filter?.outputImage?.imageByCroppingToRect(cropRect)
		}
	}
	
	public class func colorOverlay(color: UIColor) -> Filter {
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

infix operator >>> { associativity left }
public func >>> (filter1: Filter, filter2: Filter) -> Filter {
	return { image in
		if let imageAfterFilter1 = filter1(image) {
			return filter2(imageAfterFilter1)
		} else {
			return nil
		}
	}
}
