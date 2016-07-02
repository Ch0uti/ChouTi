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
    
    /**
     Check whether childViewControllers directly contain a view controller
     
     :param: childViewController View controller to be tested
     
     :returns: True if directly contained, false otherwise
     */
    public func containChildViewController(childViewController: UIViewController) -> Bool {
        return self.childViewControllers.contains(childViewController)
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
        navigationController?.navigationBar.addSubview(backgroundView)
        
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
        navigationController?.navigationBar.addSubview(backgroundView)
        
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
