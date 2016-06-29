//
//  PFFile+Extensions.swift
//  4AM
//
//  Created by Honghao Zhang on 2015-12-01.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import Foundation
import Parse

// MARK: - Deprecated as Parse is dead.
@available(*, deprecated = 9.0, message="RIP, Parse")
public extension PFFile {
	
	/**
	*Asynchronously* gets image from the PFFile
	
	This method will execute the progressBlock periodically with the percent progress.
	`progressBlock` will get called with `100` before `resultBlock` is called.
	
	- parameter resultBlock:   The result block for getting the image
	- parameter progressBlock: The block should have the following argument signature: ^(int percentDone)
	*/
	public func getImageInBackgroundWithBlock(resultBlock: (image: UIImage?, error: NSError?) -> Void, progressBlock: PFProgressBlock? = nil) {
		getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) in
			guard error == nil else {
				resultBlock(image: nil, error: error)
				return
			}
			
			guard let imageData = imageData, let image = UIImage(data:imageData) else {
				resultBlock(image: nil, error: NSError(domain: "get image failed", code: -1, userInfo: nil))
				return
			}
			
			resultBlock(image: image, error: error)
			
		}, progressBlock: progressBlock)
	}
}
