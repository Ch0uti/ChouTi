//
//  CollectionViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-10.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

public class CollectionViewCell : UICollectionViewCell {
	
	let textLabel = UILabel()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		setupViews()
		setupConstraints()
	}
	
	private func setupViews() {
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(textLabel)
	}

	private func setupConstraints() {
		var constraints = [NSLayoutConstraint]()

		constraints += [
			NSLayoutConstraint(item: textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
			NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
		]

		NSLayoutConstraint.activateConstraints(constraints)
	}
}

extension CollectionViewCell : CollectionViewCellInfo {
	public class func identifier() -> String {
		return NSStringFromClass(CollectionViewCell.self)
	}
	
	public class func registerInCollectionView(collectionView: UICollectionView) {
		collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier())
		collectionView.scrollEnabled = false
	}
}
