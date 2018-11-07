//
//  UIImage+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-02.
//

import UIKit

// MARK: - Tint with Gradient Colors
public extension UIImage {
    /**
     Create a gradient color tinted image from top to bottom
     
     :param: colors Gradient colors, from top to bottom.
     
     :returns: A tinted image
     */
    func tintedVerticallyWithLinearGradientColors(_ colors: [UIColor], blenMode: CGBlendMode = .normal) -> UIImage {
        return tintedWithLinearGradientColors(colors, blenMode: blenMode, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
    }

    /**
     Create a gradient color tinted image from left to right
     
     :param: colors Gradient colors, from left to right.
     
     :returns: A tinted image
     */
    func tintedHorizontallyWithLinearGradientColors(_ colors: [UIColor], blenMode: CGBlendMode = .normal) -> UIImage {
        return tintedWithLinearGradientColors(colors, blenMode: blenMode, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
    }

    /**
     Create a gradient color tinted image
     References: http://stackoverflow.com/questions/8098130/how-can-i-tint-a-uiimage-with-gradient
     https://coffeeshopped.com/2010/09/iphone-how-to-dynamically-color-a-uiimage
     
     :param: colors     Gradient colors, from start point to end point.
     :param: blenMode   A blend mode.
     :param: startPoint The coordinate that defines the starting point of the gradient.
     :param: endPoint   The coordinate that defines the ending point of the gradient.
     
     :returns: A tinted image
     */
    func tintedWithLinearGradientColors(_ colors: [UIColor], blenMode: CGBlendMode, startPoint: CGPoint, endPoint: CGPoint) -> UIImage {

        // Create a context with image size
        UIGraphicsBeginImageContext(CGSize(width: size.width * scale, height: size.height * scale))
        let context = UIGraphicsGetCurrentContext()!

        // Translate and flip graphic to LLO
        context.flipCoordinatesVertically()

        // Draw image with CGImage and add mask
        let rect = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
        context.draw(cgImage!, in: rect)
        context.clip(to: rect, mask: cgImage!)

        // Translate and flip graphic to ULO
        context.flipCoordinatesVertically()

        // Blend Mode
        context.setBlendMode(blenMode)

        // Add gradient colors
        let CGColors = colors.map { $0.cgColor }
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: CGColors as CFArray, locations: nil)
        let startPoint = CGPoint(x: size.width * scale * startPoint.x, y: size.height * scale * startPoint.y)
        let endPoint = CGPoint(x: size.width * scale * endPoint.x, y: size.height * scale * endPoint.y)
        let drawingOptions = CGGradientDrawingOptions([.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: drawingOptions)

        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return gradientImage!
    }
}

// MARK: - Resize
public extension UIImage {
    /**
     Get a new scalled image with max width or max heigth, image size ratio is kept.
     
     - parameter maxWidth:  max width
     - parameter maxHeight: max height
     
     - returns: image with new size
     */
    func scaledToMaxWidth(_ maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let oldHeight = self.size.height

        let scaleFactor = (oldWidth > oldHeight) ? maxWidth / oldWidth : maxHeight / oldHeight

        let newWidth = oldWidth * scaleFactor
        let newHeight = oldHeight * scaleFactor

        let newSize = CGSize(width: newWidth, height: newHeight)

        return self.scaledToSize(newSize)
    }

    /**
     Get a new scaled image with new size, image size ratio is not kept.
     
     - parameter size: new size
     
     - returns: image with new size.
     */
    func scaledToSize(_ size: CGSize) -> UIImage {
        guard self.size != size else {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return newImage!
    }

    // TODO: Check this methdo and update scaled method, write tests
//    func scaled(_ newSize: CGSize) -> UIImage {
//        guard size != newSize else {
//            return self
//        }
//        
//        let ratio = max(newSize.width / size.width, newSize.height / size.height)
//        let width = size.width * ratio
//        let height = size.height * ratio
//        
//        let scaledRect = CGRect(
//            x: (newSize.width - width) / 2.0,
//            y: (newSize.height - height) / 2.0,
//            width: width, height: height)
//        
//        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
//        defer { UIGraphicsEndImageContext() }
//        
//        draw(in: scaledRect)
//        
//        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
//    }
}

// MARK: - Factory Methods
public extension UIImage {
    /**
     Create a rectangle image with fill color and optional border color
     
     - parameter fillColor:   fillColor
     - parameter size:        image size in points
     - parameter borderWidth: borderWidth in points
     - parameter borderColor: borderColor
     
     - returns: new UIImage
     */
    class func imageWithColor(_ fillColor: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0), borderWidth: CGFloat = 0.0, borderColor: UIColor? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: CGPoint.zero, size: size)

        context!.setFillColor(fillColor.cgColor)
        context!.fill(rect)

        if let borderColor = borderColor, borderWidth > 0.0 {
            context!.setStrokeColor(borderColor.cgColor)
            context!.setLineWidth(borderWidth * UIScreen.main.scale)
            context!.stroke(rect)
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}

// MARK: - Mutating Image
public extension UIImage {
    /// Apply a new alpha value for an image.
    ///
    /// - Parameter alpha: New alpha value.
    /// - Returns: New image with the alpha provided
    func imageByApplyingAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.size.height)

        context.setAlpha(alpha)
        guard let cgImage = cgImage else {
            return self
        }
        context.draw(cgImage, in: rect)

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }

        return newImage
    }

	/// Apply a new tint color for an image, only alpha channel is kept
	/// Reference: https://github.com/Raizlabs/BonMot/blob/master/Sources/Image%2BTinting.swift
	/// 
	/// - Parameter tintColor: new tint color
	/// - Returns: A tinted copy of the image.
    func imageByApplyingTintColor(_ tintColor: UIColor) -> UIImage {
		let imageRect = CGRect(origin: .zero, size: size)

		// Save original properties
		let originalCapInsets = capInsets
		let originalResizingMode = resizingMode
		let originalAlignmentRectInsets = alignmentRectInsets

		UIGraphicsBeginImageContextWithOptions(size, false, scale)

		defer {
			UIGraphicsEndImageContext()
		}

		guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
			return self
		}

		// Flip the context vertically
		context.translateBy(x: 0.0, y: size.height)
		context.scaleBy(x: 1.0, y: -1.0)

		// Image tinting mostly inspired by http://stackoverflow.com/a/22528426/255489

		// Draw alpha-mask
		context.setBlendMode(.normal)
		context.draw(cgImage, in: imageRect)

		// Draw tint color, preserving alpha values of original image
		// .sourceIn: resulting color = source color * destination alpha
		context.setBlendMode(.sourceIn)
		context.setFillColor(tintColor.cgColor)
		context.fill(imageRect)

		guard var image = UIGraphicsGetImageFromCurrentImageContext() else {
			return self
		}

		// Prevent further tinting
		image = image.withRenderingMode(.alwaysOriginal)

		// Restore original properties
		image = image.withAlignmentRectInsets(originalAlignmentRectInsets)
		if originalCapInsets != image.capInsets || originalResizingMode != image.resizingMode {
			image = image.resizableImage(withCapInsets: originalCapInsets, resizingMode: originalResizingMode)
		}

		// Transfer accessibility label (watchOS not included; does not have accessibilityLabel on UIImage).
		#if os(iOS) || os(tvOS)
			image.accessibilityLabel = self.accessibilityLabel
		#endif

		return image
	}

	/**
	Expand image with insets
	
	- parameter insets: inset want to expand
	
	- returns: new expanded image
	*/
    func imageExpandedWithInsets(_ insets: UIEdgeInsets) -> UIImage {
        let newSize = CGSize(width: size.width + insets.left + insets.right, height: size.height + insets.top + insets.bottom)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        self.draw(in: CGRect(x: insets.left, y: insets.top, width: size.width, height: size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    /**
     Get cropped image with rect specified
     Ref: http://stackoverflow.com/a/7704399/3164091
     
     - parameter rect: rect
     
     - returns: cropped image
     */
    func imageCroppedWithRect(_ rect: CGRect) -> UIImage? {
        let rect = CGRect(x: rect.origin.x * scale,
                          y: rect.origin.y * scale,
                          width: rect.width * scale,
                          height: rect.height * scale)
        guard let imageRef = self.cgImage!.cropping(to: rect) else {
            return nil
        }
        let croppedImage = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return croppedImage
    }

    /**
     Fill rect on image.
     
     - parameter fillRect: fillRect.
     - parameter color:    color to fill.
     
     - returns: new image.
     */
    func fillRect(_ fillRect: CGRect, withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        let imageRect = CGRect(origin: CGPoint.zero, size: size)

        // Ref: http://stackoverflow.com/a/15153062/3164091
        // Ref: http://trandangkhoa.blogspot.ca/2009/07/iphone-os-drawing-image-and-stupid.html
        // Save current status of graphics context
        context!.saveGState()

        // Do stupid stuff to draw the image correctly
        context!.translateBy(x: 0, y: size.height)
        context!.scaleBy(x: 1.0, y: -1.0)

        if imageOrientation == .left {
            context!.rotate(by: .pi / 2)
            context!.translateBy(x: 0, y: -size.width)
        } else if imageOrientation == .right {
            context!.rotate(by: -.pi / 2)
            context!.translateBy(x: -size.height, y: 0)
        } else if imageOrientation == .up {
            // Do nothing
        } else if imageOrientation == .down {
            context!.translateBy(x: size.width, y: size.height)
            context!.rotate(by: .pi)
        }

        context!.draw(cgImage!, in: imageRect)

        // After drawing the image, roll back all transformation by restoring the old context
        context!.restoreGState()

        context!.setFillColor(color.cgColor)
        context!.fill(fillRect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}

// MARK: - Get Color from UIImage
public extension UIImage {
    /**
     Get the color for a pixel.
     Ref: http://stackoverflow.com/questions/35029672/getting-pixel-color-from-an-image-using-cgpoint
     
     - parameter point: the position for the pixel
     
     - returns: returns color for the pixel.
     */
    func colorAtPoint(_ point: CGPoint) -> UIColor {
        guard let cgImage = self.cgImage else {
            return UIColor.clear
        }
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        assert(0 <= point.x && point.x < width)
        assert(0 <= point.y && point.y < height)

        let context = createBitmapContext(cgImage)

        let data = context!.data!.assumingMemoryBound(to: UInt8.self)

        let offset = Int(4 * (point.y * width + point.x))

		let alpha: UInt8 = data[offset]
		let red: UInt8 = data[offset + 1]
		let green: UInt8 = data[offset + 2]
		let blue: UInt8 = data[offset + 3]

        // Dealloc memeory allocated in createBitmapContext
        free(data)

        let color = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)

        return color
    }

    private func createBitmapContext(_ image: CGImage) -> CGContext? {

        // Get image width, height
        let pixelsWide = image.width
        let pixelsHigh = image.height

        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)

        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // Allocate memory for image data. This is the destination in memory where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let size = CGSize(width: CGFloat(pixelsWide), height: CGFloat(pixelsHigh))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // Create bitmap
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8,
                                bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        // Draw the image onto the context
        let rect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)
        context!.draw(image, in: rect)

        return context
    }
}
