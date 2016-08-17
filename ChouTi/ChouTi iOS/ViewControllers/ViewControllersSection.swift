//
//  ViewControllersSection.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-16.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

class ViewControllersSection: NSObject, TableViewSectionType {
    var headerTitle: String? = "View Controller Containers"
    var footerTitle: String? = nil
    var shouldShowIndex: Bool = false
    var rows: [TableViewRowType] = []
    
    override init() {
        super.init()
        
        rows.append(
            TableViewRow(title: "SlideController",
                subtitle: "Has Left/Right Menu View Controller",
                cellSelectAction: { indexPath, cell in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    
                    let centerVC = CenterViewController(nibName: "CenterViewController", bundle: nil)
                    centerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Done, target: self, action: #selector(ViewControllersSection.expandLeft(_:)))
                    centerVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .Done, target: self, action: #selector(ViewControllersSection.expandRight(_:)))
                    centerVC.title = "Slide Controller"
                    
                    let centerNavi = UINavigationController(rootViewController: centerVC)
                    
                    let leftVC = DummyViewController(label: "Left")
                    let rightVC = DummyViewController(label: "Right")
                    
                    let slideViewController = SlideController(centerViewController: centerNavi, leftViewController: leftVC, rightViewController: rightVC)
                    self.slideViewController = slideViewController
                    
                    slideViewController.animationDuration = 0.25
                    slideViewController.springDampin = 1.0
                    
                    slideViewController.statusBarBackgroundColor = UIColor.whiteColor()
                    slideViewController.leftRevealWidth = 200
                    slideViewController.rightRevealWidth = 100
                    
                    slideViewController.shouldExceedRevealWidth = false
                    
                    centerVC.slideViewController = slideViewController
                    centerVC.leftViewController = leftVC
                    centerVC.rightViewController = rightVC
                    
                    cell?.tableView?.presentingViewController?.presentViewController(slideViewController, animated: true, completion: nil)
            })
        )
        
        rows.append(
            TableViewRow(title: "Page View Controller",
                subtitle: "Paging View Controller",
                cellSelectAction: { indexPath, cell in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(PageViewDemoController(), sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "Menu Page View Controller",
                subtitle: "Paging View Controller with Top Menus",
                cellSelectAction: { indexPath, cell in
                    cell?.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
                    cell?.tableView?.presentingViewController?.showViewController(MenuPageDemoViewController(), sender: nil)
                }
            )
        )
    }
    
    var slideViewController: SlideController!
    
    func expandLeft(sender: AnyObject) {
        slideViewController.toggleLeftViewController()
    }
    
    func expandRight(sender: AnyObject) {
        slideViewController.toggleRightViewController()
    }
}
