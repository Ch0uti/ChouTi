//
//  NSLayoutConstraint+Retrieve.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-09-09.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit

// TODO: 参考另一个framework关于如何找回constraint

public extension UIView {
    func constraints(withFirstItem firstItem: AnyObject, // TODO: nil or not
                     firstAttribute: NSLayoutConstraint.Attribute? = nil,
                     relation: NSLayoutConstraint.Relation? = nil,
                     secondItem: AnyObject? = nil,
                     secondAttribute: NSLayoutConstraint.Attribute? = nil,
                     multiplier: CGFloat? = nil,
                     constant: CGFloat? = nil) -> [NSLayoutConstraint] {
		return constraints.filter {
			let isFirstItem = $0.firstItem === firstItem
			let isFirstAttribute = (firstAttribute == nil) ? true : $0.firstAttribute == firstAttribute
			let isRelation = (relation == nil) ? true : $0.relation == relation
			let isSecondItem = $0.secondItem === secondItem
			let isSecondAttribute = (secondAttribute == nil) ? true : $0.secondAttribute == secondAttribute
			let isMultiplier = (multiplier == nil) ? true : $0.multiplier == multiplier
			let isConstant = (constant == nil) ? true : $0.constant == constant

			return isFirstItem && isFirstAttribute && isRelation && isSecondItem && isSecondAttribute && isMultiplier && isConstant
		}
    }

    var widthConstraint: NSLayoutConstraint? {
        return constraints(withFirstItem: self, firstAttribute: .width, relation: .equal, secondItem: nil, secondAttribute: .notAnAttribute).first
    }

	var heightConstraint: NSLayoutConstraint? {
		return constraints(withFirstItem: self, firstAttribute: .height, relation: .equal, secondItem: nil, secondAttribute: .notAnAttribute).first
	}
}
