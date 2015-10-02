//
//  CollectionViewCellInfo.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-02.
//
//

import UIKit

public protocol CollectionViewCellInfo {
	static func identifier() -> String
	static func registerInCollectionView(collectionView: UICollectionView)
}
