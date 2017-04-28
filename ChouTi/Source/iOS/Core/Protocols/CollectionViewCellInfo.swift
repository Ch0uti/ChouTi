//
//  CollectionViewCellInfo.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-02.
//
//

import UIKit

public protocol CollectionViewCellInfo {
	// return String(self)
	static func identifier() -> String
	
	// collectionView.registerClass(self, forCellWithReuseIdentifier: identifier())
	static func registerInCollectionView(_ collectionView: UICollectionView)
}



// Sample Implementation:

//// MARK: - CollectionViewCellInfo
//extension <#CollectionViewCell#> : CollectionViewCellInfo {
//	open class func identifier() -> String {
//		return String(self)
//	}
//	
//	open class func registerInCollectionView(collectionView: UICollectionView) {
//		collectionView.registerClass(self, forCellWithReuseIdentifier: identifier())
//	}
//}
