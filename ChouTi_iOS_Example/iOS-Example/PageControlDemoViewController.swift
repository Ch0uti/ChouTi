//
//  PageControlDemoViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2016-06-09.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class PageControlDemoViewController: UIViewController {
    let systemPageControl = UIPageControl()
    let pageControl = PageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Page Control Demo"
        view.backgroundColor = UIColor.random()
        
        systemPageControl.numberOfPages = 5
        systemPageControl.backgroundColor = UIColor.blackColor()
        systemPageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(systemPageControl)
        
        pageControl.numberOfPages = 5
        pageControl.backgroundColor = UIColor.blackColor()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activateConstraints([
                systemPageControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
                systemPageControl.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -40),
                pageControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
                pageControl.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 40)
                ]
            )
        } else {
            // Fallback on earlier versions
        }
        
        delay(0.5) {
            self.pageControl.set(currentPage: 1, progress: 0.2)
            delay(0.2) {
                self.pageControl.set(currentPage: 1, progress: 0.4)
                delay(0.2) {
                    self.pageControl.set(currentPage: 1, progress: 0.6)
                    delay(0.2) {
                        self.pageControl.set(currentPage: 1, progress: 0.8)
                        delay(0.2) {
                            self.pageControl.set(currentPage: 1, progress: 1.0)
                            
                            delay(0.5) {
                                self.pageControl.set(currentPage: 1, animated: true)
                                delay(1.1) {
                                    self.pageControl.set(currentPage: 2, animated: false)
                                    delay(1.1) {
                                        self.pageControl.set(currentPage: 3, animated: true)
                                        delay(1.1) {
                                            self.pageControl.set(currentPage: 1, animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
}
