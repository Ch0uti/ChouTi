//
//  TextTableCollectionViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

class TextTableCollectionViewCell: UICollectionViewCell {
    var textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textLabel)

		setupConstraints()
    }

	private func setupConstraints() {
		contentView.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
		contentView.addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
	}
}
