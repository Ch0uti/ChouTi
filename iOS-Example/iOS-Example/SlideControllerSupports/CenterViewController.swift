//
//  CenterViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-08-28.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit
import ChouTi

class CenterViewController: UIViewController {
	
	weak var slideViewController: SlideController?
	var leftViewController: SideViewController?
	var rightViewController: SideViewController?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		print("CenterViewController: viewWillAppear")
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		print("CenterViewController: viewDidAppear")
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		print("CenterViewController: viewWillDisappear")
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		print("CenterViewController: viewDidDisappear")
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func exitTapped(sender: UIButton) {
		dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func left(sender: UISwitch) {
		slideViewController?.leftViewController = sender.on ? leftViewController : nil
	}
	
	
	@IBAction func right(sender: UISwitch) {
		slideViewController?.rightViewController = sender.on ? rightViewController : nil
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
