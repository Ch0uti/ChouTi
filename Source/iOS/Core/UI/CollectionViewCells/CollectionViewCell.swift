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

	public func commonInit() {
		setupViews()
		setupConstraints()
	}
	
	private func setupViews() {
		backgroundColor = UIColor.whiteColor()
		
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(textLabel)
		
		let selectedBackgroundView = UIView()
		selectedBackgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
		self.selectedBackgroundView = selectedBackgroundView
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



// MARK: - CollectionViewCellInfo
extension CollectionViewCell : CollectionViewCellInfo {
	public class func identifier() -> String {
		return String(self)
	}
	
	public class func registerInCollectionView(collectionView: UICollectionView) {
		collectionView.registerClass(self, forCellWithReuseIdentifier: identifier())
	}
}
