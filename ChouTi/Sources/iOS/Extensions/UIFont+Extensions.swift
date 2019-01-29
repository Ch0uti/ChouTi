// Copyright © 2019 ChouTi. All rights reserved.

import UIKit

public extension UIFont {
    class func gillSansFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GillSans", size: fontSize)
    }

    class func gillSansLightFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GillSans-Light", size: fontSize)
    }

    class func gillSansItalicFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GillSans-Italic", size: fontSize)
    }
}

// MARK: - Helvetica

public extension UIFont {
    class func helveticaNenueFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue", size: fontSize)
    }

    class func helveticaNeueLightFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Light", size: fontSize)
    }

    class func helveticaNenueThinFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Thin", size: fontSize)
    }
}

// MARK: - Arial

public extension UIFont {
    class func ArialMTFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "ArialMT", size: fontSize)
    }

    class func AvenirMediumFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Medium", size: fontSize)
    }

    class func AvenirRomanFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Roman", size: fontSize)
    }

    class func AvenirHeavyFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Heavy", size: fontSize)
    }

    class func AvenirBookFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Book", size: fontSize)
    }
}
