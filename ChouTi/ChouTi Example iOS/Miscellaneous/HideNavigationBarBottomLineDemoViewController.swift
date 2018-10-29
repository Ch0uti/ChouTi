//
//  HideNavigationBarBottomLineDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-12-02.
//  Copyright © 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class HideNavigationBarBottomLineDemoViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hideBottomHairline()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            // Being poped
            navigationController?.navigationBar.showBottomHairline()
        } else if isMovingToParent {
            // Being pushed
        }
    }
}
