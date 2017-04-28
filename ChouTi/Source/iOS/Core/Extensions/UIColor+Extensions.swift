//
//  UIColor+Extensions.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-09-04.
//

import UIKit

public extension UIColor {
    /**
     Get Red component from this UIColor
     
     :returns: Red value
     */
    public func redComponent() -> CGFloat {
        var red: CGFloat = 0.0
        self.getRed(&red, green: nil, blue: nil, alpha: nil)
        return red
    }
    
    /**
     Get Green component from this UIColor
     
     :returns: Green value
     */
    public func greenComponent() -> CGFloat {
        var green: CGFloat = 0.0
        self.getRed(nil, green: &green, blue: nil, alpha: nil)
        return green
    }
    
    /**
     Get Blue component from this UIColor
     
     :returns: Blue value
     */
    public func blueComponent() -> CGFloat {
        var blue: CGFloat = 0.0
        self.getRed(nil, green: nil, blue: &blue, alpha: nil)
        return blue
    }
    
    /**
     Get Alpha component from this UIColor
     
     :returns: Alpha value
     */
    public func alphaComponent() -> CGFloat {
        var alpha: CGFloat = 0.0
        self.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }
    
    /**
     Get (Red, Green, Blue, Alpha) components from this UIColor
     
     :returns: (Red, Green, Blue, Alpha)
     */
    public func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}



public extension UIColor {
    public class func random(_ randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
}

public extension UIColor {
    /**
     Get color between two colors, with percentage
     
     - parameter minColor: color on one end
     - parameter maxColor: color on the other end
     - parameter percent:  percentage from minColor
     
     - returns: color between two colors
     */
    public class func colorBetweenMinColor(_ minColor: UIColor, maxColor: UIColor, percent: CGFloat) -> UIColor {
        let (leftR, leftG, leftB, leftA) = minColor.getRGBAComponents()
        let (rightR, rightG, rightB, rightA) = maxColor.getRGBAComponents()
        
        let newR = leftR.toNumber(rightR, withPercent: percent)
        let newG = leftG.toNumber(rightG, withPercent: percent)
        let newB = leftB.toNumber(rightB, withPercent: percent)
        let newA = leftA.toNumber(rightA, withPercent: percent)
        
        return UIColor(red: newR, green: newG, blue: newB, alpha: newA)
    }

    /**
     Get a darker color for self
     
     - parameter brightnessDecreaseFactor: factor applied to brightness, should be greater than 0.0 and less than 1.0
     
     - returns: a darker UIColor object
     */
    public func darkerColor(brightnessDecreaseFactor: CGFloat = 0.75) -> UIColor {
        let brightnessDecreaseFactor = brightnessDecreaseFactor.normalize(0.0, 1.0)
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * brightnessDecreaseFactor, alpha: alpha)
        }
		
        return self
    }
    
    /**
     Get a lighter color for self
     
     - returns: a lighter color
     */
    public func lighterColor(brightnessIncreaseFactor: CGFloat = 1.3) -> UIColor {
        let brightnessIncreaseFactor = brightnessIncreaseFactor.normalize(1.0, CGFloat.greatestFiniteMagnitude)
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * brightnessIncreaseFactor, alpha: alpha)
        }
        
        return self
    }
}

// MARK: - HEX Colors
// Optional Pod:
//   pod 'UIColor_Hex_Swift' ( https://github.com/yeahdongcn/UIColor-Hex-Swift )
//   pod 'SwiftHEXColors' ( https://github.com/thii/SwiftHEXColors )
public extension UIColor {
    /**
     UIColor(hexString: "#CC0000")
     
     - parameter hexString: hexString, e.g. "#CC0000"
     
     - returns: UIColor
     */
    public convenience init?(hexString: String) {
        guard hexString.hasPrefix("#") else {
            return nil
        }
        guard hexString.characters.count == "#000000".characters.count else {
            return nil
        }
        let digits = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 1))
        guard Int(digits, radix: 16) != nil else {
            return nil
        }
        let red = digits.substring(to: digits.characters.index(digits.startIndex, offsetBy: 2))
        let green = digits.substring(with: digits.characters.index(digits.startIndex, offsetBy: 2) ..< digits.characters.index(digits.startIndex, offsetBy: 4))
        let blue = digits.substring(with: digits.characters.index(digits.startIndex, offsetBy: 4) ..< digits.characters.index(digits.startIndex, offsetBy: 6))
        let redf = CGFloat(Double(Int(red, radix: 16)!) / 255.0)
        let greenf = CGFloat(Double(Int(green, radix: 16)!) / 255.0)
        let bluef = CGFloat(Double(Int(blue, radix: 16)!) / 255.0)
        self.init(red: redf, green: greenf, blue: bluef, alpha: CGFloat(1.0))
    }
    
    /// Get Hex6 String, e.g. "#CC0000"
    public var hexString: String {
        let colorRef = self.cgColor.components
        
        let r: CGFloat = colorRef![0]
        let g: CGFloat = colorRef![1]
        let b: CGFloat = colorRef![2]
        
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
