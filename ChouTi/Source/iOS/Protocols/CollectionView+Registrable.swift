//
//  CollectionView+Registrable.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2015-10-02.
//  Copyright © 2018 ChouTi. All rights reserved.
//

import UIKit

public protocol CollectionViewCellRegistrable {

	/// Default cell reuse identifier for cell.
	/// Sample: `return String(describing: self)`.
	///
	/// - Returns: A cell reuse identifier.
	static func identifier() -> String

	/// Register cell in collection view.
	/// Sample: `collectionView.register(self, forCellWithReuseIdentifier: identifier())`.
	///
	/// - Parameter collectionView: The target collection view to use this cell.
	static func register(inCollectionView collectionView: UICollectionView)

	/// Register cell with nib in collection view.
	///
	/// - Parameters:
	///   - nib: A nib object that specifies the nib file to use to create the cell.
	///   - collectionView: Target collection view to use this cell.
	static func registerNib(_ nib: UINib, inCollectionView collectionView: UICollectionView)

	/// Unregister cell in collection view.
	///
	/// - Parameter collectionView: The collection view registered this cell
	static func unregister(inCollectionView collectionView: UICollectionView)

	/// Unregister cell with nib in collection view.
	///
	/// - Parameter collectionView: The collection view registered this cell.
	static func unregisterNib(inCollectionView collectionView: UICollectionView)
}

// MARK: - CollectionViewRegistrable
extension UICollectionViewCell: CollectionViewCellRegistrable {
	open class func identifier() -> String {
		return String(describing: self)
	}

	open class func register(inCollectionView collectionView: UICollectionView) {
		collectionView.register(self, forCellWithReuseIdentifier: identifier())
	}

	open class func registerNib(_ nib: UINib, inCollectionView collectionView: UICollectionView) {
		collectionView.register(nib, forCellWithReuseIdentifier: identifier())
	}

	open class func unregister(inCollectionView collectionView: UICollectionView) {
		collectionView.register(nil as AnyClass?, forCellWithReuseIdentifier: identifier())
	}

	open class func unregisterNib(inCollectionView collectionView: UICollectionView) {
		collectionView.register(nil as UINib?, forCellWithReuseIdentifier: identifier())
	}
}

// MARK: - Cell Registration + Dequeuing
extension UICollectionView {

	/// Register cell with class type
	///
	/// - Parameter class: collection view cell class which conforms CollectionViewCellRegistrable.
	open func register<T: CollectionViewCellRegistrable>(cellClass class: T.Type) {
		`class`.register(inCollectionView: self)
	}

	/// Register cell with nib and class type
	///
	/// - Parameters:
	///   - nib: A nib object that specifies the nib file to use to create the cell.
	///   - class: collection view cell class which conforms CollectionViewCellRegistrable.
	open func register<T: CollectionViewCellRegistrable>(_ nib: UINib, forClass class: T.Type) {
		`class`.registerNib(nib, inCollectionView: self)
	}

	/// Returns a reusable cell object located by its class type and index path.
	/// This call will raise a fatal error if the cell was not registered with `identifier()`.
	///
	/// - Parameters:
	///   - class: The class type for the dequeuing cell.
	///   - indexPath: The index path specifying the location of the cell.
	/// - Returns: A valid CollectionViewCellRegistrable object with correct type.
	open func dequeueReusableCell<T: CollectionViewCellRegistrable>(withClass class: T.Type, for indexPath: IndexPath) -> T {
		guard let cell = self.dequeueReusableCell(withReuseIdentifier: `class`.identifier(), for: indexPath) as? T else {
			fatalError("Error: cell with identifier: \(`class`.identifier()) for index path: \(indexPath) is not \(T.self)")
		}
		return cell
	}
}
