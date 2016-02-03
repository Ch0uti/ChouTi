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
     Get a UIImage instance with color, size is 1.0 * 1.0
     
     - parameter color: color of the image
     
     - returns: new UIImage with the color provided
     */
    public class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     Get a UIImage instance with color and size
     
     - parameter color: color of the image
     - parameter size:  size of the image
     
     - returns: new UIImage with the color provided
     */
    public class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
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
}
