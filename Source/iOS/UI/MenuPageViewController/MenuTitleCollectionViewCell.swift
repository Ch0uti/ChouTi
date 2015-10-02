//
//  MenuTitleCollectionViewCell.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-02.
//
//

import UIKit

class MenuTitleCollectionViewCell: UICollectionViewCell {
	
	let titleLabel = UILabel()
	
	override var selected: Bool {
		didSet {
			titleLabel.textColor = selected ? UIColor.redColor() : UIColor.blackColor()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(titleLabel)
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		var constraints = [NSLayoutConstraint]()
		
		if #available(iOS 9.0, *) {
			constraints.append(titleLabel.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor))
			constraints.append(titleLabel.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor))
		} else {
			constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
			constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
		}
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
}

extension MenuTitleCollectionViewCell: CollectionViewCellInfo {
	static func identifier() -> String {
		return NSStringFromClass(MenuTitleCollectionViewCell)
	}
	
	static func registerInCollectionView(collectionView: UICollectionView) {
		collectionView.registerClass(MenuTitleCollectionViewCell.self, forCellWithReuseIdentifier: MenuTitleCollectionViewCell.identifier())
	}
} 
