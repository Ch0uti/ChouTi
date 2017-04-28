//
//  CenterViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2015-08-28.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class CenterViewController: UIViewController {
    
    weak var slideViewController: SlideController?
    var leftViewController: DummyViewController?
    var rightViewController: DummyViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CenterViewController: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("CenterViewController: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("CenterViewController: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("CenterViewController: viewDidDisappear")
    }
    
    @IBAction func exitTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func left(_ sender: UISwitch) {
        slideViewController?.leftViewController = sender.isOn ? leftViewController : nil
    }
    
    
    @IBAction func right(_ sender: UISwitch) {
        slideViewController?.rightViewController = sender.isOn ? rightViewController : nil
    }
}
