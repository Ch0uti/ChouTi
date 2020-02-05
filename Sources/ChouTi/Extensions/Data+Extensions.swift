//
//  File.swift
//  
//
//  Created by Honghao Zhang on 2/5/20.
//

import Foundation

// MARK: - Data to String

public extension Data {

	/// Get string from self with an encoding.
	/// - Parameter encoding: The encoding type.
	func string(encoding: String.Encoding) -> String? {
		String(data: self, encoding: encoding)
	}
}
