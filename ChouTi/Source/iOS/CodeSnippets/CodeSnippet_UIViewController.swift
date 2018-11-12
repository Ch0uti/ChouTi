//
//  Created by Honghao Zhang on 11/24/2015.
//  Copyright © 2018 ChouTi. All rights reserved.
//

//import UIKit
//
//class <#ViewController#>: UIViewController {
//    
//    // MARK: - Init
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        commonInit()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func commonInit() {
//        // <#Common Init#>
//    }
//    
//    // MARK: - Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//        setupConstraints()
//    }
//    
//    private func setupViews() {
//        // TODO: Setup view hierarchy
//        <#view#>.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(<#view#>)
//    }
//    
//    private func setupConstraints() {
//        // TODO: Setup constraints
//        let views = [
//            "view" : <#view#>
//        ]
//        
//        let metrics: [String : CGFloat] = [
//            "vertical_spacing" : 4.0
//        ]
//        
//        var constraints = [NSLayoutConstraint]()
//        
//        // TODO: Add constraints
//        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view]-|", options: [], metrics: metrics, views: views)
//        
//        NSLayoutConstraint.activate(constraints)
//    }
//}

// MARK: - Detecting Poping or Pushing

//override func viewWillDisappear(animated: Bool) {
//	super.viewWillDisappear(animated)
//	
//	if isMovingFromParentViewController() {
//		// This view controller will be poped
//	} else if isMovingToParentViewController() {
//		// Some View Controller will push onto
//	} else {
//		print("Warning: view controller: \(self) is not poping or being pushed")
//	}
//}
