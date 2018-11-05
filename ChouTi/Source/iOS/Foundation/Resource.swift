//
//  ResourceBundle.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-29.
//
//

import Foundation

// MARK: - Pod Resources
open class Resource {
	public static let sharedResource = Resource()
	public static var bundle: Bundle? {
		return Resource.sharedResource?._bundle
	}

	private var _bundle: Bundle?

	public init?() {
		let podBundle = Bundle(for: Resource.self)
		guard let bundleURL = podBundle.url(forResource: "Resources", withExtension: "bundle") else {
            assertionFailure("Error: Could not load the bundle (ChouTi)")
			return
		}

		_bundle = Bundle(url: bundleURL)
	}
}
