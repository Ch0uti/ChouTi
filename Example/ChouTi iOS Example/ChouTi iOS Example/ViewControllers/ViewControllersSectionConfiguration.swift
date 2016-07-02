//
//  ViewControllersSectionConfiguration.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-07-01.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import Foundation
import ChouTi

class ViewControllersSectionConfiguration: NSObject {
    
    var section: TableViewSectionType!
    
    var slideViewController: SlideController!
    
    init(tableView: UITableView) {
        super.init()
        
        var rows: [TableViewRowType] = []
        rows.append(
            TableViewRow(title: "SlideController",
                subtitle: "Has Left/Right Menu View Controller",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    
                    let centerVC = CenterViewController(nibName: "CenterViewController", bundle: nil)
                    centerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Done, target: self, action: #selector(ViewControllersSectionConfiguration.expandLeft(_:)))
                    centerVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .Done, target: self, action: #selector(ViewControllersSectionConfiguration.expandRight(_:)))
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
                    
                    tableView.presentingViewController?.presentViewController(slideViewController, animated: true, completion: nil)
            })
        )
        
        rows.append(
            TableViewRow(title: "Page View Controller",
                subtitle: "Paging View Controller",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = PageViewDemoController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )
        
        rows.append(
            TableViewRow(title: "Menu Page View Controller",
                subtitle: "Paging View Controller with Top Menus",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoViewController = MenuPageDemoViewController()
                    tableView.presentingViewController?.showViewController(demoViewController, sender: nil)
                }
            )
        )

        section = TableViewSection(headerTitle: "View Controller Containers", rows: rows, tableView: tableView)
    }
    
    func expandLeft(sender: AnyObject) {
        slideViewController.toggleLeftViewController()
    }
    
    func expandRight(sender: AnyObject) {
        slideViewController.toggleRightViewController()
    }
}
