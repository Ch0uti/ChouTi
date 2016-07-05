//
//  UIViewController+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-28.
//
//

import UIKit

// MARK: - Storyboard
public extension UIViewController {
    
    /**
     Initialize a view controller in storyboard.
     
     :param: storyboardName     Storyboard name
     :param: viewControllerName Storyboard ID of the view controller
     
     :returns: An instance of view controller.
     */
    class public func viewControllerInStoryboard(storyboardName: String , viewControllerName: String) -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerName)
        return viewController
    }
}



// MARK: - Utility
public extension UIViewController {
    /// Retrieve the view controller currently on-screen
    ///
    /// Based off code here: http://stackoverflow.com/questions/24825123/get-the-current-view-controller-from-the-app-delegate
    public class var currentViewController: UIViewController? {
        if let controller = UIApplication.sharedApplication().keyWindow?.rootViewController {
            return findCurrentViewController(controller)
        }
        return nil
    }
    
    private class func findCurrentViewController(controller: UIViewController) -> UIViewController {
        if let controller = controller.presentedViewController {
            return findCurrentViewController(controller)
        }
        else if let controller = controller as? UISplitViewController, lastViewController = controller.viewControllers.first where controller.viewControllers.count > 0 {
            return findCurrentViewController(lastViewController)
        }
        else if let controller = controller as? UINavigationController, topViewController = controller.topViewController where controller.viewControllers.count > 0 {
            return findCurrentViewController(topViewController)
        }
        else if let controller = controller as? UITabBarController, selectedViewController = controller.selectedViewController where controller.viewControllers?.count > 0 {
            return findCurrentViewController(selectedViewController)
        }
        else {
            return controller
        }
    }
}



// MARK: - UI
public extension UIViewController {
    
    /**
     Create a left navigation bar backrgound view, this view will spans between leading and title's leading
     
     - returns: a newly created background view
     */
    public func addLeftNavigationBarBackgroundView() -> UIView? {
        guard let navigationBar = navigationController?.navigationBar else {
            NSLog("navigationBar is nil")
            return nil
        }
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraintEqualToAnchor(navigationBar.leadingAnchor).active = true
        
        if let titleView = navigationItem.titleView {
            backgroundView.trailingAnchor.constraintEqualToAnchor(titleView.leadingAnchor).active = true
        } else {
            backgroundView.trailingAnchor.constraintEqualToAnchor(navigationBar.centerXAnchor).active = true
        }
        
        backgroundView.topAnchor.constraintEqualToAnchor(navigationBar.topAnchor).active = true
        backgroundView.bottomAnchor.constraintEqualToAnchor(navigationBar.bottomAnchor).active = true
        
        return backgroundView
    }
    
    /**
     Create a right navigation bar backrgound view, this view will spans between title's trailing and trailing
     
     - returns: a newly created background view
     */
    public func addRightNavigationBarBackgroundView() -> UIView? {
        guard let navigationBar = navigationController?.navigationBar else {
            NSLog("navigationBar is nil")
            return nil
        }
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(backgroundView)
        
        backgroundView.trailingAnchor.constraintEqualToAnchor(navigationBar.trailingAnchor).active = true
        
        if let titleView = navigationItem.titleView {
            backgroundView.leadingAnchor.constraintEqualToAnchor(titleView.trailingAnchor).active = true
        } else {
            backgroundView.leadingAnchor.constraintEqualToAnchor(navigationBar.centerXAnchor).active = true
        }
        
        backgroundView.topAnchor.constraintEqualToAnchor(navigationBar.topAnchor).active = true
        backgroundView.bottomAnchor.constraintEqualToAnchor(navigationBar.bottomAnchor).active = true
        
        return backgroundView
    }
}
