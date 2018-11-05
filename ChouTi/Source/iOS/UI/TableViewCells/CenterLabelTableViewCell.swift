//
//  CenterLabelTableViewCell.swift
//  Pods
//
//  Created by Honghao Zhang on 2016-12-30.
//
//

import UIKit

open class CenterLabelTableViewCell: UITableViewCell {

	public let titleLabel = UILabel()

	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	open func commonInit() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(titleLabel)
		titleLabel.centerXAnchor.constrain(to: contentView.centerXAnchor)
		titleLabel.topAnchor.constrain(to: contentView.layoutMarginsGuide.topAnchor)
		titleLabel.bottomAnchor.constrain(to: contentView.layoutMarginsGuide.bottomAnchor)
	}
}
