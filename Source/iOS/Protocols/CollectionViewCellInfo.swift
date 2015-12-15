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
	static func registerInCollectionView(collectionView: UICollectionView)
}



// Sample Implementation:

//// MARK: - CollectionViewCellInfo
//extension <#CollectionViewCell#> : CollectionViewCellInfo {
//	public class func identifier() -> String {
//		return String(self)
//	}
//	
//	public class func registerInCollectionView(collectionView: UICollectionView) {
//		collectionView.registerClass(self, forCellWithReuseIdentifier: identifier())
//	}
//}
