//
//  UIFont+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-02.
//
//

import UIKit

public extension UIFont {
	public class func gillSansFont(_ fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "GillSans", size: fontSize)
	}
	
	public class func gillSansLightFont(_ fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "GillSans-Light", size: fontSize)
	}
	
	public class func gillSansItalicFont(_ fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "GillSans-Italic", size: fontSize)
	}
}

// MARK: - Helvetica
public extension UIFont {
    public class func helveticaNenueFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue", size: fontSize)
    }
    
    public class func helveticaNeueLightFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Light", size: fontSize)
    }
    
    public class func helveticaNenueThinFont(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "HelveticaNeue-Thin", size: fontSize)
    }
}

// MARK: - Arial
public extension UIFont {
	public class func ArialMTFont(_ fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "ArialMT", size: fontSize)
	}
	
	public class func AvenirMediumFont(_ fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Medium", size: fontSize)
	}
	
	public class func AvenirRomanFont(_ fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Roman", size: fontSize)
	}
	
	public class func AvenirHeavyFont(_ fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Heavy", size: fontSize)
	}
	
	public class func AvenirBookFont(_ fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Book", size: fontSize)
	}
}
