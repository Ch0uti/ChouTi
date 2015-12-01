//
//  Parse+Extensions.swift
//  4AM
//
//  Created by Honghao Zhang on 2015-11-30.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

//import Foundation
//import Parse
//
//extension Parse {
//	
//	typealias VoidBlock = Void -> Void
//	typealias PFObjectConfigurationBlock = PFObject? -> Void
//	typealias PFObjectConfigurationAndSaveBridge = (object: PFObject?, configuration: PFObjectConfigurationBlock?, save: VoidBlock) -> Void
//	
//	static var defaultConfigurationAndSaveBridge: PFObjectConfigurationAndSaveBridge {
//		return { object, configuration, save in
//			configuration?(object)
//			save()
//		}
//	}
//	
//	static func updateObjectWithClassName(className: String,
//		uniqueIdKey: String,
//		uniqueId: String,
//		configuration: PFObjectConfigurationBlock?,
//		saveCompletion: PFBooleanResultBlock?)
//	{
//		let query = PFQuery(className: className)
//		query.whereKey(uniqueIdKey, equalTo: uniqueId)
//		query.findObjectsInBackgroundWithBlock { objects, error in
//			guard error == nil else {
//				log.error("\(error!) \(error!.userInfo)")
//				saveCompletion?(false, error)
//				return
//			}
//			
//			guard let objects = objects else {
//				log.error("objects are nil")
//				saveCompletion?(false, NSError(domain: "objects are nil", code: -1, userInfo: nil))
//				return
//			}
//			
//			let object: PFObject
//			if objects.count == 0 {
//				// Create new object
//				object = PFObject(className: className)
//			} else if objects.count == 1 {
//				// Update
//				object = objects.first!
//			} else {
//				// Warning
//				log.warning("Find more than one object: \(objects)")
//				object = objects.first!
//			}
//			
//			object[uniqueIdKey] = uniqueId
//			
//			Parse.defaultConfigurationAndSaveBridge(object: object, configuration: configuration, save: {
//				object.saveInBackgroundWithBlock(saveCompletion)
//			})
//		}
//	}
//	
//	static func findObjectWithClassName(className: String,
//		uniqueIdKey: String,
//		uniqueId: String,
//		completion: PFObjectConfigurationBlock?)
//	{
//		let query = PFQuery(className: className)
//		query.whereKey(uniqueIdKey, equalTo: uniqueId)
//		query.findObjectsInBackgroundWithBlock { objects, error in
//			guard error == nil else {
//				log.error("\(error) \(error?.userInfo)")
//				completion?(nil)
//				return
//			}
//			
//			guard let objects = objects else {
//				log.error("objects are nil")
//				completion?(nil)
//				return
//			}
//			
//			if objects.count == 0 {
//				// Not found
//				completion?(nil)
//			} else if objects.count == 1 {
//				// Find One
//				completion?(objects.first!)
//			} else {
//				// Warning
//				log.warning("Find more than one object: \(objects)")
//				completion?(objects.first!)
//			}
//		}
//	}
//}
