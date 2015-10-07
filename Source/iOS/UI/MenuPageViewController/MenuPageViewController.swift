//
//  MenuPageViewController.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-10-02.
//
//

import UIKit

public class MenuPageViewController: UIViewController {
	public var menuTitleHeight: CGFloat = 44.0
	
	private let menuCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
	private let pageScrollView = UIScrollView()
	
    public override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		
		setupViews()
    }
	
	private func setupViews() {
		menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(menuCollectionView)
		
		MenuTitleCollectionViewCell.registerInCollectionView(menuCollectionView)
		
		menuCollectionView.backgroundColor = UIColor.lightGrayColor()
		menuCollectionView.dataSource = self
		menuCollectionView.delegate = self
		
		menuCollectionView.scrollEnabled = true
		menuCollectionView.bounces = true
		menuCollectionView.alwaysBounceHorizontal = true
		menuCollectionView.directionalLockEnabled = true
		
		menuCollectionView.allowsMultipleSelection = false
		menuCollectionView.showsHorizontalScrollIndicator = false
		menuCollectionView.showsVerticalScrollIndicator = false
		
		pageScrollView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(pageScrollView)
		pageScrollView.directionalLockEnabled = true
		pageScrollView.delegate = self
		pageScrollView.scrollEnabled = true
		pageScrollView.bounces = true
		pageScrollView.alwaysBounceHorizontal = true
		pageScrollView.directionalLockEnabled = true
		pageScrollView.showsHorizontalScrollIndicator = false
		pageScrollView.showsVerticalScrollIndicator = false
		
		setupConstraints()
	}
	
	private func setupConstraints() {
		view.layoutMargins = UIEdgeInsetsZero
		
		let views = ["menuCollectionView": menuCollectionView, "pageScrollView": pageScrollView]
		let metrics = ["menuTitleHeight": menuTitleHeight]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuCollectionView]|", options: [], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[menuCollectionView(menuTitleHeight)][pageScrollView]|", options: [.AlignAllLeading, .AlignAllTrailing], metrics: metrics, views: views)
		
		NSLayoutConstraint.activateConstraints(constraints)
	}
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		menuCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
	}
	
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
}



extension MenuPageViewController {
	private func removeViewController(viewController: UIViewController) {
		viewController.willMoveToParentViewController(nil)
		viewController.view.removeFromSuperview()
		viewController.removeFromParentViewController()
	}
	
	private func addViewController(viewController: UIViewController) {
		addChildViewController(viewController)
		view.addSubview(viewController.view)
		viewController.didMoveToParentViewController(self)
	}
}



// MARK: - UICollectionViewDataSource
extension MenuPageViewController: UICollectionViewDataSource {
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MenuTitleCollectionViewCell.identifier(), forIndexPath: indexPath) as! MenuTitleCollectionViewCell
		
		cell.titleLabel.text = "Haha"
		
		return cell
	}
}



// MARK: - UICollectionViewDelegate
extension MenuPageViewController: UICollectionViewDelegate {
	
}



// MARK: - UIScrollViewDelegate
extension MenuPageViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y != 0 {
			scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
		}
	}
}
