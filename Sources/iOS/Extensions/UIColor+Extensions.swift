// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public extension UIColor {
    /**
     Get Red component from this UIColor

     :returns: Red value
     */
    func redComponent() -> CGFloat {
        var red: CGFloat = 0.0
        getRed(&red, green: nil, blue: nil, alpha: nil)
        return red
    }

    /**
     Get Green component from this UIColor

     :returns: Green value
     */
    func greenComponent() -> CGFloat {
        var green: CGFloat = 0.0
        getRed(nil, green: &green, blue: nil, alpha: nil)
        return green
    }

    /**
     Get Blue component from this UIColor

     :returns: Blue value
     */
    func blueComponent() -> CGFloat {
        var blue: CGFloat = 0.0
        getRed(nil, green: nil, blue: &blue, alpha: nil)
        return blue
    }

    /**
     Get Alpha component from this UIColor

     :returns: Alpha value
     */
    func alphaComponent() -> CGFloat {
        var alpha: CGFloat = 0.0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }

    /**
     Get (Red, Green, Blue, Alpha) components from this UIColor

     :returns: (Red, Green, Blue, Alpha)
     */
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}

public extension UIColor {
    class func random(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random(in: 0...1.0)
        let randomGreen = CGFloat.random(in: 0...1.0)
        let randomBlue = CGFloat.random(in: 0...1.0)
        let alpha = randomAlpha ? CGFloat.random(in: 0...1.0) : 1.0
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
    class func colorBetweenMinColor(_ minColor: UIColor, maxColor: UIColor, percent: CGFloat) -> UIColor {
        let (leftR, leftG, leftB, leftA) = minColor.getRGBAComponents()
        let (rightR, rightG, rightB, rightA) = maxColor.getRGBAComponents()

        let newR = lerp(start: leftR, end: rightR, t: percent)
        let newG = lerp(start: leftG, end: rightG, t: percent)
        let newB = lerp(start: leftB, end: rightB, t: percent)
        let newA = lerp(start: leftA, end: rightA, t: percent)

        return UIColor(red: newR, green: newG, blue: newB, alpha: newA)
    }

    /**
     Get a darker color for self

     - parameter brightnessDecreaseFactor: factor applied to brightness, should be greater than 0.0 and less than 1.0

     - returns: a darker UIColor object
     */
    func darkerColor(brightnessDecreaseFactor: CGFloat = 0.75) -> UIColor {
        let brightnessDecreaseFactor = brightnessDecreaseFactor.normalize(0.0, 1.0)
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * brightnessDecreaseFactor, alpha: alpha)
        }

        return self
    }

    /**
     Get a lighter color for self

     - returns: a lighter color
     */
    func lighterColor(brightnessIncreaseFactor: CGFloat = 1.3) -> UIColor {
        let brightnessIncreaseFactor = brightnessIncreaseFactor.normalize(1.0, CGFloat.greatestFiniteMagnitude)
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * brightnessIncreaseFactor, alpha: alpha)
        }

        return self
    }
}

// MARK: - HEX Colors

// The MIT License (MIT)
//
// Copyright (c) 2014 R0CKSTAR
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

public extension UIColor {
    /**
     The shorthand three-digit hexadecimal representation of color.
     #RGB defines to the color #RRGGBB.

     - parameter hex3: Three-digit hexadecimal value.
     - parameter alpha: 0.0 - 1.0. The default is 1.0.
     */
    convenience init(hex3: UInt16, alpha: CGFloat = 1) {
        let divisor = CGFloat(15)
        let red = CGFloat((hex3 & 0xF00) >> 8) / divisor
        let green = CGFloat((hex3 & 0x0F0) >> 4) / divisor
        let blue = CGFloat(hex3 & 0x00F) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     The shorthand four-digit hexadecimal representation of color with alpha.
     #RGBA defines to the color #RRGGBBAA.

     - parameter hex4: Four-digit hexadecimal value.
     */
    convenience init(hex4: UInt16) {
        let divisor = CGFloat(15)
        let red = CGFloat((hex4 & 0xF000) >> 12) / divisor
        let green = CGFloat((hex4 & 0x0F00) >> 8) / divisor
        let blue = CGFloat((hex4 & 0x00F0) >> 4) / divisor
        let alpha = CGFloat(hex4 & 0x000F) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.

     - parameter hex6: Six-digit hexadecimal value.
     */
    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
        let blue = CGFloat(hex6 & 0x0000FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     The six-digit hexadecimal representation of color with alpha of the form #RRGGBBAA.

     - parameter hex8: Eight-digit hexadecimal value.
     */
    convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let red = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let green = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
        let blue = CGFloat((hex8 & 0x0000FF00) >> 8) / divisor
        let alpha = CGFloat(hex8 & 0x000000FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     The rgba string representation of color with alpha of the form #RRGGBBAA/#RRGGBB.

     - parameter hexString: String value represents rgba values.
     */
    convenience init?(hexString: String) {
        guard hexString.hasPrefix("#") else {
            return nil
        }

        let hexString = String(hexString[String.Index(encodedOffset: 1)...])
        var hexValue: UInt32 = 0

        guard Scanner(string: hexString).scanHexInt32(&hexValue) else {
            return nil
        }

        switch hexString.count {
        case 3:
            self.init(hex3: UInt16(hexValue))
        case 4:
            self.init(hex4: UInt16(hexValue))
        case 6:
            self.init(hex6: hexValue)
        case 8:
            self.init(hex8: hexValue)
        default:
            return nil
        }
    }

    /**
     Hex string of a UIColor instance, fails to nil.

     - parameter includeAlpha: Whether the alpha should be included.
     */
    func hexString(includeAlpha: Bool = true) -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)

        guard r >= 0, r <= 1, g >= 0, g <= 1, b >= 0, b <= 1 else {
            return nil
        }

        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}
