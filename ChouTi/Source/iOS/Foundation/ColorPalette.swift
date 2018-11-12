//
//  ColorPalette.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-05-05.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public enum ColorPalette {
    // Black
    public static var rockBlackColor = UIColor(red: 0.18, green: 0.19, blue: 0.25, alpha: 1.00)

    // Red
    public static var tallPoppyRedColor = UIColor(red: 0.75, green: 0.15, blue: 0.17, alpha: 1.00)

    // Purple
    public static var slackSidebarPurpleColor = UIColor(red: 0.31, green: 0.24, blue: 0.31, alpha: 1.00)

    // Blue
    public static var facebookBlueColor = UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.00)// UIColor(hexString: "#3b5998")!
    public static var facebookMediumBlueColor = UIColor(red: 109.0 / 255.0, green: 132.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.00)// UIColor(hexString: "#6d84b4")!
    public static var madisonDarkBlueColor = UIColor(red: 0.04, green: 0.18, blue: 0.36, alpha: 1.00)
    public static var sapphireBlueColor = UIColor(red: 0.19, green: 0.31, blue: 0.65, alpha: 1.00)

    // Green
    public static var lightSeaGreenColor = UIColor(red: 0.10, green: 0.66, blue: 0.62, alpha: 1.00)
    public static var puertoRoseYellowColor = UIColor(red: 0.31, green: 0.76, blue: 0.63, alpha: 1.00)

    // Yellow
    public static var texasRoseYellowColor = UIColor(red: 0.99, green: 0.67, blue: 0.31, alpha: 1.00)
}

// MARK: - Flat Colors (https://flatuicolors.com)
public extension ColorPalette {
    /// Turquoise/绿松石   rgb(26, 188, 156)   #1abc9c
    static var turquoiseGreen = UIColor(red: 26 / 255.0, green: 188 / 255.0, blue: 156 / 255.0, alpha: 1.0)
    /// Emerald/祖母绿   rgb(46, 204, 113)   #2ecc71
    static var emeraldGreen = UIColor(red: 46 / 255.0, green: 204 / 255.0, blue: 113 / 255.0, alpha: 1.0)
    /// Peter River   rgb(52, 152, 219)   #3498db
    static var peterRiverBlue = UIColor(red: 52 / 255.0, green: 152 / 255.0, blue: 219 / 255.0, alpha: 1.0)
    /// Amethyst/紫水晶   rgb(155, 89, 182)   #9b59b6
    static var amethystPurple = UIColor(red: 155 / 255.0, green: 89 / 255.0, blue: 182 / 255.0, alpha: 1.0)
    /// Wer Asphalt/湿沥青   rgb(52, 73, 94)   #34495e
    static var wetAsphaltBlack = UIColor(red: 52 / 255.0, green: 73 / 255.0, blue: 94 / 255.0, alpha: 1.0)

    /// Green Sea   rgb(22, 160, 133)   #16a085
    static var greenSeaGreen = UIColor(red: 22 / 255.0, green: 160 / 255.0, blue: 133 / 255.0, alpha: 1.0)
    /// Nephritis/肾炎   rgb(39, 174, 96)   #27ae60
    static var nephritisGreen = UIColor(red: 39 / 255.0, green: 174 / 255.0, blue: 96 / 255.0, alpha: 1.0)
    /// Belize Hole/伯利兹大蓝洞   rgb(41, 128, 185)   #2980b9
    static var belizeHoleBlue = UIColor(red: 41 / 255.0, green: 128 / 255.0, blue: 185 / 255.0, alpha: 1.0)
    /// Wisteria/紫藤   rgb(142, 68, 173)   #8e44ad
    static var wisteriaPurple = UIColor(red: 142 / 255.0, green: 68 / 255.0, blue: 173 / 255.0, alpha: 1.0)
    /// Midnight Blue   rgb(44, 62, 80)   #2c3e50
    static var midnightBlue = UIColor(red: 44 / 255.0, green: 62 / 255.0, blue: 80 / 255.0, alpha: 1.0)

    /// Sun Flower   rgb(241, 196, 15)   #f1c40f
    static var sunFlowerYellow = UIColor(red: 241 / 255.0, green: 196 / 255.0, blue: 15 / 255.0, alpha: 1.0)
    /// Carrot   rgb(230, 126, 34)   #e67e22
    static var carrotOrange = UIColor(red: 230 / 255.0, green: 126 / 255.0, blue: 34 / 255.0, alpha: 1.0)
    /// Alizarin/茜素   rgb(231, 76, 60)   #e74c3c
    static var alizarinRed = UIColor(red: 231 / 255.0, green: 76 / 255.0, blue: 60 / 255.0, alpha: 1.0)
    /// Clouds   rgb(236, 240, 241)   #ecf0f1
    static var cloudsWhite = UIColor(red: 236 / 255.0, green: 240 / 255.0, blue: 241 / 255.0, alpha: 1.0)
    /// Concrete   rgb(149, 165, 166)   #95a5a6
    static var concreteGray = UIColor(red: 149 / 255.0, green: 165 / 255.0, blue: 166 / 255.0, alpha: 1.0)

    /// Orange   rgb(243, 156, 18)   #f39c12
    static var orange = UIColor(red: 243 / 255.0, green: 156 / 255.0, blue: 18 / 255.0, alpha: 1.0)
    /// Pumpkin   rgb(211, 84, 0)   #d35400
    static var pumpkinOrange = UIColor(red: 211 / 255.0, green: 84 / 255.0, blue: 0 / 255.0, alpha: 1.0)
    /// Pomegranate/石榴   rgb(192, 57, 43)   #c0392b
    static var pomegranateRed = UIColor(red: 192 / 255.0, green: 57 / 255.0, blue: 43 / 255.0, alpha: 1.0)
    /// Silver   rgb(189, 195, 199)   #bdc3c7
    static var silverGray = UIColor(red: 189 / 255.0, green: 195 / 255.0, blue: 199 / 255.0, alpha: 1.0)
    /// Asbestos/石棉   rgb(127, 140, 141)   #7f8c8d
    static var asbestosGray = UIColor(red: 127 / 255.0, green: 140 / 255.0, blue: 141 / 255.0, alpha: 1.0)
}
