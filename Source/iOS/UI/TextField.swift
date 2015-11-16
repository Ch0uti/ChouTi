//
//  TextField.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-14.
//
//

import UIKit

public class TextField: UITextField {
	
	public var textHorizontalPadding: CGFloat = 10.0
	public var textVerticalPadding: CGFloat = 10.0
	
	public override func textRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, textHorizontalPadding, textVerticalPadding)
	}
	
	public override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, textHorizontalPadding, textVerticalPadding)
	}
	
	public override func editingRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, textHorizontalPadding, textVerticalPadding)
	}
}
