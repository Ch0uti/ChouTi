//
//  Created by Honghao Zhang on 1/11/2016.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import QuartzCore

public enum CIImageFilter {
	public typealias Filter = (CIImage) -> CIImage?

	public static func gaussianBlur(_ radius: Double) -> Filter {
		return { image in
			let parameters = [
				kCIInputRadiusKey: radius,
				kCIInputImageKey: image
			] as [String: Any]

			let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters)
			return filter?.outputImage
		}
	}

	public static func constantColorGenerator(_ color: Color) -> Filter {
		return { _ in
			let parameters = [kCIInputColorKey: CIColor(color: color)]
			let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters)
			return filter?.outputImage
		}
	}

	public static func sourceOverCompositing(_ overlayImage: CIImage) -> Filter {
		return { image in
			let parameters = [
				kCIInputImageKey: overlayImage,
				kCIInputBackgroundImageKey: image
			]
			let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameters)
			let cropRect = image.extent
            return filter?.outputImage?.cropped(to: cropRect)
		}
	}

	public static func colorOverlay(_ color: Color) -> Filter {
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
