//
//  UIFont+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-02.
//
//

import UIKit

public extension UIFont {
	public class func helveticaNenueFont(fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "HelveticaNeue", size: fontSize)
	}
	
	public class func helveticaNeueLightFont(fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "HelveticaNeue-Light", size: fontSize)
	}
	
	public class func helveticaNenueThinFont(fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "HelveticaNeue-Thin", size: fontSize)
	}
	
	public class func ArialMTFont(fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "ArialMT", size: fontSize)
	}
	
	public class func AvenirMediumFont(fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Medium", size: fontSize)
	}
	
	public class func AvenirRomanFont(fontSize: CGFloat) -> UIFont? {
		return UIFont(name: "Avenir-Roman", size: fontSize)
	}
}
