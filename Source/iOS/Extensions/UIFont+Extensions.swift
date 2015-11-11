//
//  UIFont+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-02.
//
//

import Foundation

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
}