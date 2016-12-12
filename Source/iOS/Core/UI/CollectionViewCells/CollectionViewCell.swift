//
//  CollectionViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-12-10.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

open class CollectionViewCell : UICollectionViewCell {
	
	let textLabel = UILabel()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	open func commonInit() {
		setupViews()
		setupConstraints()
	}
	
	fileprivate func setupViews() {
		backgroundColor = UIColor.white
		
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(textLabel)
		
		let selectedBackgroundView = UIView()
		selectedBackgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
		self.selectedBackgroundView = selectedBackgroundView
	}

	fileprivate func setupConstraints() {
		var constraints = [NSLayoutConstraint]()

		constraints += [
			NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
			NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
		]

		NSLayoutConstraint.activate(constraints)
	}
}



// MARK: - CollectionViewCellInfo
extension CollectionViewCell : CollectionViewCellInfo {
	public class func identifier() -> String {
		return String(describing: self)
	}
	
	public class func registerInCollectionView(_ collectionView: UICollectionView) {
		collectionView.register(self, forCellWithReuseIdentifier: identifier())
	}
}
