//
//  PageControlDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-06-09.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class PageControlDemoViewController: UIViewController {
    let scrollView = UIScrollView()
    
    let systemPageControl = UIPageControl()
    let pageControl = PageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Page Control Demo"
        view.backgroundColor = UIColor.whiteColor()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.constrainToFullSizeInSuperview()
        
        scrollView.contentSize = CGSize(width: view.width * 5, height: view.height)
        for i in 0 ..< 5 {
            let v = randomView()
            v.x = view.width * CGFloat(i)
            scrollView.addSubview(v)
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.pagingEnabled = true
        
        scrollView.delegate = self
        
        systemPageControl.numberOfPages = 5
        systemPageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(systemPageControl)
        systemPageControl.addTarget(self, action: #selector(PageControlDemoViewController.pageControlUpdated(_:)), forControlEvents: .ValueChanged)
        
        pageControl.numberOfPages = 5
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(PageControlDemoViewController.pageControlUpdated(_:)), forControlEvents: .ValueChanged)
        
        pageControl.scrollView = scrollView
        
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activateConstraints([
                pageControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
                pageControl.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -40),
                systemPageControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
                systemPageControl.bottomAnchor.constraintEqualToAnchor(pageControl.bottomAnchor, constant: -40)
                ]
            )
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delay(1.0) {
            self.pageControl.set(currentPage: 2, animated: true)
        }.then(1.0) {
            self.pageControl.set(currentPage: 1, animated: true)
        }.then(1.0) {
            self.pageControl.set(currentPage: 0, animated: true)
        }
    }
    
    func randomView() -> UIView {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height))
        v.backgroundColor = UIColor.random()
        return v
    }
    
    func testAppearance() {
        Task.delay(0.5) {
            self.pageControl.currentPageIndicatorTintColor = UIColor.random()
        }.then(1.0) {
            self.pageControl.pageIndicatorTintColor = UIColor.random()
        }.then(0.5) {
            self.pageControl.pageIndicatorSize *= 2
        }.then(0.5) { 
            self.pageControl.pageIndicatorSize /= 2
            self.pageControl.pageIndicatorSpacing += 10
        }.then(0.5) { 
            self.pageControl.pageIndicatorSpacing -= 10
        }
    }
    
    func pageControlUpdated(sender: AnyObject?) {
        if let systemPageControl = sender as? UIPageControl {
            print("systemPageControl: \(systemPageControl.currentPage)")
        }
        
        if let pageControl = sender as? PageControl {
            print("pageControl: \(pageControl.currentPage)")
        }
    }
}

extension PageControlDemoViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        systemPageControl.currentPage = scrollView.pageIndex
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        systemPageControl.currentPage = scrollView.pageIndex
    }
}

extension UIScrollView {
    var pageIndex: Int {
        guard bounds.width > 0 else { return 0 }
        return Int(contentOffset.x) / Int(bounds.width)
    }
}
