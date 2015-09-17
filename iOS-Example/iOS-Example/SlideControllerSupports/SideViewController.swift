//
//  SideViewController.swift
//  iOS-Example
//
//  Created by Honghao Zhang on 2015-08-28.
//  Copyright (c) 2015 Honghao Zhang. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {

	@IBOutlet weak var label: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		print("\(label.text!)ViewController: viewWillAppear")
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		print("\(label.text!)ViewController: viewDidAppear")
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		print("\(label.text!)ViewController: viewWillDisappear")
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		print("\(label.text!)ViewController: viewDidDisappear")
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
