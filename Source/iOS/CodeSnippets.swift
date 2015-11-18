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


// MARK: - UIImage + Assets

//extension UIImage {
//	
//	enum ImageAssets: String {
//		case AppIcon = "AppIcon"
//		case LaunchImage = "LaunchImage"
//		case TTCLogo = "TTCLogo"
//		case Alert = "BMWhiteLabelSDK.bundle/BMAdvisoryButton"
//		case Menu = "BMWhiteLabelSDK.bundle/BMSideMenuButton"
//		case ActiveTicket = "BMActiveTicketsSmartTile"
//		case BuyTicket = "BMBuyTicketsSmartTile"
//		
//		case Home = "BMWhiteLabelSDK.bundle/BMHome"
//		case Buy = "BMWhiteLabelSDK.bundle/BMBuyPasses"
//		case Use = "BMWhiteLabelSDK.bundle/BMUsePasses"
//		case MoreInfo = "BMWhiteLabelSDK.bundle/BMMoreInformation"
//		case Settings = "BMWhiteLabelSDK.bundle/BMSettings"
//		case SignOut = "BMWhiteLabelSDK.bundle/BMLogout"
//	}
//	
//	convenience init!(asset: ImageAssets) {
//		self.init(named: asset.rawValue)
//	}
//}
