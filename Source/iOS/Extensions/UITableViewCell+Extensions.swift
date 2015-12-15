//
//  UITableViewCell+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-14.
//
//

import UIKit

public extension UITableViewCell {
	
	/**
	Enable full width separtor for UITableViewCell
	Note: This will mutate separtor inset and layout margins, call this method carefully
	*/
	public func enableFullWidthSeparator() {
		preservesSuperviewLayoutMargins = false
		separatorInset = UIEdgeInsetsZero
		layoutMargins = UIEdgeInsetsZero
	}
}
