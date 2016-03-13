//
//  MainViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-08-10.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var slideViewController: SlideController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        title = "🗄 抽屉(ChouTi) Demo"
        navigationController?.navigationBar.titleTextColor = UIColor(red:252/255.0, green:43/255.0, blue:27/255.0, alpha:255/255.0)
        navigationController?.navigationBar.titleTextFont = UIFont.boldSystemFontOfSize(18)
    }
    
    func setupTableView() {
        var sections: [TableViewSectionType] = []
        
        // MARK: - View Controller Container Section
        var viewControllerContainerRows = [TableViewRowType]()
        
        viewControllerContainerRows.append(
            TableViewRow(title: "SlideController",
                subtitle: "Has Left/Right Menu View Controller",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let centerVC = CenterViewController(nibName: "CenterViewController", bundle: nil)
                    centerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Done, target: self, action: "expandLeft:")
                    centerVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .Done, target: self, action: "expandRight:")
                    centerVC.title = "Slide Controller"
                    
                    let centerNavi = UINavigationController(rootViewController: centerVC)
                    
                    let leftVC = SideViewController(nibName: "SideViewController", bundle: nil)
                    leftVC.view.backgroundColor = UIColor.redColor()
                    leftVC.label.text = "Left"
                    leftVC.view.frame = UIScreen.mainScreen().bounds
                    
                    let rightVC = SideViewController(nibName: "SideViewController", bundle: nil)
                    rightVC.view.backgroundColor = UIColor.blueColor()
                    rightVC.label.text = "Right"
                    rightVC.view.frame = UIScreen.mainScreen().bounds
                    
                    self.slideViewController = SlideController(centerViewController: centerNavi, leftViewController: leftVC, rightViewController: rightVC)
                    
                    self.slideViewController.animationDuration = 0.25
                    self.slideViewController.springDampin = 1.0
                    
                    self.slideViewController.statusBarBackgroundColor = UIColor.whiteColor()
                    self.slideViewController.leftRevealWidth = 200
                    self.slideViewController.rightRevealWidth = 100
                    
                    self.slideViewController.shouldExceedRevealWidth = false
                    
                    centerVC.slideViewController = self.slideViewController
                    centerVC.leftViewController = leftVC
                    centerVC.rightViewController = rightVC
                    
                    self.slideViewController.toggleLeftViewController()
                    
                    self.presentViewController(self.slideViewController, animated: true, completion: nil)
            })
        )
        
        viewControllerContainerRows.append(
            TableViewRow(title: "Page View Controller",
                subtitle: "Paging View Controller",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(PageViewDemoController(), animated: true)
                }
            )
        )
        
        viewControllerContainerRows.append(
            TableViewRow(title: "Menu Page View Controller",
                subtitle: "Paging View Controller with Top Menus",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(MenuPageDemoViewController(), animated: true)
                }
            )
        )
        
        sections.append(
            TableViewSection(headerTitle: "View Controller Containers", rows: viewControllerContainerRows, tableView: tableView)
        )
        
        
        
        // MARK: - View Section
        var viewRows = [TableViewRowType]()
        
        viewRows.append(
            TableViewRow(title: "Menu View",
                subtitle: "Horizontal Menu View",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(MenuViewDemoController(), animated: true)
                }
            )
        )
        
        if #available(iOS 9.0, *) {
            viewRows.append(
                TableViewRow(title: "📷 Image Picker View Demo Controller",
                    subtitle: "Handy Image Selection View",
                    tableView: tableView,
                    cellSelectAction: { indexPath, cell in
                        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                        self.navigationController?.pushViewController(ImagePickerDemoViewController(), animated: true)
                    }
                )
            )
        }
        
        viewRows.append(
            TableViewRow(title: "Drop Down Menu Picker",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(DropDownMenuDemoViewController(), animated: true)
                }
            )
        )
        
        viewRows.append(
            TableViewRow(title: "📅 Date Picker View Controller",
                subtitle: "A Slide Up Date Picker View Controller",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(DatePickerControllerDemoViewController(), animated: true)
                }
            )
        )
        
        viewRows.append(
            TableViewRow(title: "Navigation Bar with Status Bar",
                subtitle: "Drop down style status bar under navigation bar",
                tableView: tableView,
                cellSelectAction: { (indexPath, cell) -> Void in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(NavigationBarStatusBarDemoViewController(), animated: true)
                }
            )
        )
        
        viewRows.append(
            TableViewRow(title: "Search Text Field",
                subtitle: "",
                tableView: tableView,
                cellSelectAction: { (indexPath, cell) -> Void in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(SearchTextFieldDemoViewController(), animated: true)
                }
            )
        )
        
        sections.append(
            TableViewSection(headerTitle: "Views", rows: viewRows, tableView: tableView)
        )
        
        
        
        // MARK: - Animators
        var animatorRows = [TableViewRowType]()
        animatorRows.append(
            TableViewRow(title: "Drop Presenting Animator",
                subtitle: "Path style drop down presenting",
                tableView: tableView,
                cellSelectAction: { (indexPath, cell) -> Void in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(DropPresentingDemoViewController(), animated: true)
                }
            )
        )
        
        sections.append(
            TableViewSection(headerTitle: "Animators", rows: animatorRows, tableView: tableView)
        )
        
        // MARK: - UICollectionView Layouts Section
        var layoutRows = [TableViewRowType]()
        
        if #available(iOS 9.0, *) {
            layoutRows.append(
                TableViewRow(title: "├┼┤ Table (Grid) Layout",
                    subtitle: "Excel Layout",
                    tableView: tableView,
                    cellSelectAction: { indexPath, cell in
                        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                        let tableLayoutDemoViewController = TableLayoutDemoViewController()
                        self.presentViewController(tableLayoutDemoViewController, animated: true, completion: nil)
                    }
                )
            )
        }
        
        sections.append(
            TableViewSection(headerTitle: "UICollectionView Layouts", rows: layoutRows, tableView: tableView)
        )
        
        
        
        // MARK: - Miscellaneous Section
        var otherRows = [TableViewRowType]()
        
        otherRows.append(
            TableViewRow(title: "Navigation Bar Hide Hairline",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(HideNavigationBarBottomLineDemoViewController(), animated: true)
            })
        )
        
        otherRows.append(
            TableViewRow(title: "TableView+SectionRowExtension Demo",
                subtitle: "Demo for handy table view sections and rows management",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    let demoController = TableViewSectionRowExtensionDemoViewController()
                    demoController.title = "TableView+SectionRowExtension"
                    self.navigationController?.pushViewController(demoController, animated: true)
            })
        )
        
        otherRows.append(
            TableViewRow(title: "Operations",
                subtitle: "Demo for using Operations (NSOperations)",
                tableView: tableView,
                cellSelectAction: { indexPath, cell in
                    self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    self.navigationController?.pushViewController(OperationsDemoViewController(), animated: true)
            })
        )
        
        sections.append(
            TableViewSection(headerTitle: "Miscellaneous", rows: otherRows, tableView: tableView)
        )
        
        tableView.sections = sections
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func expandLeft(sender: AnyObject) {
        slideViewController.toggleLeftViewController()
    }
    
    func expandRight(sender: AnyObject) {
        slideViewController.toggleRightViewController()
    }
}
