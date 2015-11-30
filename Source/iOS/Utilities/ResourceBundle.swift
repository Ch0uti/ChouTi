//
//  ResourceBundle.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-29.
//
//

import Foundation

// MARK: - Pod Resources
public class Resource {
	public static let sharedResource = Resource()
	public static var bundle: NSBundle? {
		return Resource.sharedResource?._bundle
	}
	
	private var _bundle: NSBundle?
	
	public init?() {
		let podBundle = NSBundle(forClass: self.dynamicType)
		guard let bundleURL = podBundle.URLForResource("Resources", withExtension: "bundle") else {
			return
		}
		
		_bundle = NSBundle(URL: bundleURL)
	}
}
