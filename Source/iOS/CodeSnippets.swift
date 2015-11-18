//
//  CodeSnippets.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-11.
//
//

import Foundation

// MARK: - Programmatically Setup Root View Controller

//class AppDelegate: UIResponder, UIApplicationDelegate {
//	
//	var window: UIWindow?
//	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//		
//		let viewController = UIViewController()
//		let navigationController = UINavigationController(rootViewController: viewController)
//		
//		window = UIWindow(frame: UIScreen.mainScreen().bounds)
//		window!.rootViewController = navigationController
//		window!.backgroundColor = .whiteColor()
//		window!.makeKeyAndVisible()
//		
//		return true
//	}
//}



// MARK: - Add View Controller

//addChildViewController(viewController)
//
//viewController.view.translatesAutoresizingMaskIntoConstraints = false
//view.addSubview(viewController.view)
//// TODO: Setup constraints...
//
//viewController.didMoveToParentViewController(self)



// MARK: - Remove View Controller

//viewController.willMoveToParentViewController(nil)
//viewController.view.removeFromSuperview()
//viewController.removeFromParentViewController()



// MARK: - NavigationBar Title Color

//navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
