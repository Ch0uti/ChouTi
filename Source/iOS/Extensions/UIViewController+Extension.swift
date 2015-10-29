//
//  UIViewController+Extension.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-28.
//
//

import Foundation

public extension UIViewController {
	public func addLeftNavigationBarBackgroundView() -> UIView? {
		guard let navigationBar = navigationController?.navigationBar else {
			NSLog("navigationBar is nil")
			return nil
		}
		
		let backgroundView = UIView()
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		navigationController?.navigationBar.addSubview(backgroundView)
		
		if #available(iOS 9.0, *) {
			backgroundView.leadingAnchor.constraintEqualToAnchor(navigationBar.leadingAnchor).active = true
			
			if let titleView = navigationItem.titleView {
				backgroundView.trailingAnchor.constraintEqualToAnchor(titleView.leadingAnchor).active = true
			} else {
				backgroundView.trailingAnchor.constraintEqualToAnchor(navigationBar.centerXAnchor).active = true
			}
			
			backgroundView.topAnchor.constraintEqualToAnchor(navigationBar.topAnchor).active = true
			backgroundView.bottomAnchor.constraintEqualToAnchor(navigationBar.bottomAnchor).active = true
		} else {
			NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: navigationBar, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			
			if let titleView = navigationItem.titleView {
				NSLayoutConstraint(item: backgroundView, attribute: .Trailing, relatedBy: .Equal, toItem: titleView, attribute: .Leading, multiplier: 1.0, constant: 0.0).active = true
			} else {
				NSLayoutConstraint(item: backgroundView, attribute: .Trailing, relatedBy: .Equal, toItem: navigationBar, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
			}
			
			NSLayoutConstraint(item: backgroundView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: backgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
		}
		
		return backgroundView
	}
	
	public func addRightNavigationBarBackgroundView() -> UIView? {
		guard let navigationBar = navigationController?.navigationBar else {
			NSLog("navigationBar is nil")
			return nil
		}
		
		let backgroundView = UIView()
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		navigationController?.navigationBar.addSubview(backgroundView)
		
		if #available(iOS 9.0, *) {
			backgroundView.trailingAnchor.constraintEqualToAnchor(navigationBar.trailingAnchor).active = true
			
			if let titleView = navigationItem.titleView {
				backgroundView.leadingAnchor.constraintEqualToAnchor(titleView.trailingAnchor).active = true
			} else {
				backgroundView.leadingAnchor.constraintEqualToAnchor(navigationBar.centerXAnchor).active = true
			}
			
			backgroundView.topAnchor.constraintEqualToAnchor(navigationBar.topAnchor).active = true
			backgroundView.bottomAnchor.constraintEqualToAnchor(navigationBar.bottomAnchor).active = true
		} else {
			NSLayoutConstraint(item: backgroundView, attribute: .Trailing, relatedBy: .Equal, toItem: navigationBar, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
			
			if let titleView = navigationItem.titleView {
				NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: titleView, attribute: .Trailing, multiplier: 1.0, constant: 0.0).active = true
			} else {
				NSLayoutConstraint(item: backgroundView, attribute: .Leading, relatedBy: .Equal, toItem: navigationBar, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
			}
			
			NSLayoutConstraint(item: backgroundView, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
			NSLayoutConstraint(item: backgroundView, attribute: .Bottom, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1.0, constant: 0.0).active = true
		}
		
		return backgroundView
	}
}
