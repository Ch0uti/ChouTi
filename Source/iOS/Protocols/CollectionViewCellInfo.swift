//
//  CollectionViewCellInfo.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-02.
//
//

import UIKit

public protocol CollectionViewCellInfo {
	// return NSStringFromClass(<#Cell#>.self)
	static func identifier() -> String
	
	// collectionView.registerClass(<#Cell#>.self, forCellWithReuseIdentifier: <#Cell#>.identifier())
	static func registerInCollectionView(collectionView: UICollectionView)
}
