//
//  PFFile+Extensions.swift
//  4AM
//
//  Created by Honghao Zhang on 2015-12-01.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import Parse

public extension PFFile {
	public func getImageInBackgroundWithBlock(completion: (image: UIImage?, error: NSError?) -> Void, progressBlock: PFProgressBlock? = nil) {
		getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) in
			guard error == nil else {
				completion(image: nil, error: error)
				return
			}
			
			guard let imageData = imageData, let image = UIImage(data:imageData) else {
				completion(image: nil, error: NSError(domain: "get image failed", code: -1, userInfo: nil))
				return
			}
			
			completion(image: image, error: error)
			
		}, progressBlock: progressBlock)
	}
}
