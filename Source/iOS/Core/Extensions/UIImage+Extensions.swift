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
    public func tintedVerticallyWithLinearGradientColors(colors: [UIColor], blenMode: CGBlendMode = .Normal) -> UIImage {
        return tintedWithLinearGradientColors(colors, blenMode: blenMode, startPoint: CGPointMake(0.5, 0), endPoint: CGPointMake(0.5, 1))
    }
    
    /**
     Create a gradient color tinted image from left to right
     
     :param: colors Gradient colors, from left to right.
     
     :returns: A tinted image
     */
    public func tintedHorizontallyWithLinearGradientColors(colors: [UIColor], blenMode: CGBlendMode = .Normal) -> UIImage {
        return tintedWithLinearGradientColors(colors, blenMode: blenMode, startPoint: CGPointMake(0, 0.5), endPoint: CGPointMake(1.0, 0.5))
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
    public func tintedWithLinearGradientColors(colors: [UIColor], blenMode: CGBlendMode, startPoint: CGPoint, endPoint: CGPoint) -> UIImage {
        
        // Create a context with image size
        UIGraphicsBeginImageContext(CGSize(width: size.width * scale, height: size.height * scale))
        let context = UIGraphicsGetCurrentContext()!
        
        // Translate and flip graphic to LLO
        context.flipCoordinatesVertically()
        
        // Draw image with CGImage and add mask
        let rect = CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale)
        CGContextDrawImage(context, rect, CGImage)
        CGContextClipToMask(context, rect, CGImage)
        
        // Translate and flip graphic to ULO
        context.flipCoordinatesVertically()
        
        // Blend Mode
        CGContextSetBlendMode(context, blenMode)
        
        // Add gradient colors
        let CGColors = colors.map { $0.CGColor }
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), CGColors, nil)
        let startPoint = CGPoint(x: size.width * scale * startPoint.x, y: size.height * scale * startPoint.y)
        let endPoint = CGPoint(x: size.width * scale * endPoint.x, y: size.height * scale * endPoint.y)
        let drawingOptions = CGGradientDrawingOptions([.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, drawingOptions)
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return gradientImage
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
    public func scaledToMaxWidth(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
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
    public func scaledToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - Factory Methods
public extension UIImage {
	/**
	Get a UIImage instance with color and size
	
	- parameter color: color of the image
	- parameter size:  size of the image, by default is 1.0 * 1.0
	
	- returns: new UIImage with the color provided
	*/
	public class func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
	
    public class func imageWithBorderRectangle(size: CGSize, borderWidth: CGFloat, borderColor: UIColor, fillColor: UIColor = UIColor.clearColor()) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: CGPointZero, size: size)
        
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        CGContextFillRect(context, rect)
        
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
        CGContextSetLineWidth(context, borderWidth)
        CGContextStrokeRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

// MARK: - Mutating Image
public extension UIImage {
	/**
	Apply a new alpha value for an image
	
	- parameter alpha: new alpha value
	
	- returns: new image with alpha provided
	*/
    public func imageByApplyingAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        
        let area: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        CGContextScaleCTM(ctx, 1, -1)
        CGContextTranslateCTM(ctx, 0, -area.size.height)
        CGContextSetBlendMode(ctx, .Multiply)
        CGContextSetAlpha(ctx, alpha)
        CGContextDrawImage(ctx, area, CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
	
	/**
	Apply a new tint color for an image, using the alpha channel
	
	- parameter tintColor: new tint color
	
	- returns: new image with tint color provided
	*/
	public func imageByApplyingTintColor(tintColor: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		let ctx = UIGraphicsGetCurrentContext()
		
		CGContextTranslateCTM(ctx, 0, size.height)
		CGContextScaleCTM(ctx, 1.0, -1.0)
		
		let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
		
		// Draw alpha-mask
		CGContextSetBlendMode(ctx, .Normal)
		CGContextDrawImage(ctx, rect, CGImage)
		
		// Draw tint color, preserving alpha values of original image
		CGContextSetBlendMode(ctx, .SourceIn)
		tintColor.setFill()
		CGContextFillRect(ctx, rect)
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
	/**
	Expand image with insets
	
	- parameter insets: inset want to expand
	
	- returns: new expanded image
	*/
    public func imageExpandedWithInsets(insets: UIEdgeInsets) -> UIImage {
        let newSize = CGSize(width: size.width + insets.left + insets.right, height: size.height + insets.top + insets.bottom)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        self.drawInRect(CGRect(x: insets.left, y: insets.top, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /**
     Get cropped image with rect specified
     Ref: http://stackoverflow.com/a/7704399/3164091
     
     - parameter rect: rect
     
     - returns: cropped image
     */
    public func croppedImage(withRect rect: CGRect) -> UIImage? {
        let rect = CGRect(x: rect.origin.x * scale,
                          y: rect.origin.y * scale,
                          width: rect.width * scale,
                          height: rect.height * scale)
        guard let imageRef = CGImageCreateWithImageInRect(self.CGImage, rect) else { return nil }
        let croppedImage = UIImage(CGImage: imageRef, scale: scale, orientation: imageOrientation)
        return croppedImage
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
    public func colorAtPoint(point: CGPoint) -> UIColor {
        guard let cgImage = self.CGImage else { return UIColor.clearColor() }
        let width = CGFloat(CGImageGetWidth(cgImage))
        let height = CGFloat(CGImageGetHeight(cgImage))
        
        assert(0 <= point.x && point.x < width)
        assert(0 <= point.y && point.y < height)
        
        let context = createBitmapContext(cgImage)
        
        let uncastedData = CGBitmapContextGetData(context)
        let data = UnsafePointer<UInt8>(uncastedData)
        
        let offset = Int(4 * (point.y * width + point.x))
        
        let alpha: UInt8 = data[offset]
        let red: UInt8 = data[offset+1]
        let green: UInt8 = data[offset+2]
        let blue: UInt8 = data[offset+3]
        
        // dealloc memeory allocated in createBitmapContext
        free(UnsafeMutablePointer<Void>(data))
        
        let color = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha)/255.0)
        
        return color
    }
    
    private func createBitmapContext(image: CGImageRef) -> CGContextRef? {
        
        // Get image width, height
        let pixelsWide = CGImageGetWidth(image)
        let pixelsHigh = CGImageGetHeight(image)
        
        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let size = CGSize(width: CGFloat(pixelsWide), height: CGFloat(pixelsHigh))
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // create bitmap
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8,
                                            bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        // draw the image onto the context
        let rect = CGRect(x: 0, y: 0, width: pixelsWide, height: pixelsHigh)
        CGContextDrawImage(context, rect, image)
        
        return context
    }
}
