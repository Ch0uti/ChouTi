//
//  CodeSnippet_UIView.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-11-20.
//
//

//import UIKit
//
//class <#View#>: UIView {
//	
//	let <#view#> = UIView()
//	
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		commonInit()
//	}
//	
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		commonInit()
//	}
//	
//	private func commonInit() {
//		setupViews()
//		setupConstraints()
//	}
//
//	private func setupViews() {
//		// TODO: Setup view hierarchy
//		<#view#>.translatesAutoresizingMaskIntoConstraints = false
//		addSubview(<#view#>)
//	}
//
//	private func setupConstraints() {
//		preservesSuperviewLayoutMargins = false
//		layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//		
//		let views = [
//			"view" : <#view#>
//		]
//		
//		let metrics: [String : CGFloat] = [
//			"vertical_spacing" : 4.0
//		]
//		
//		var constraints = [NSLayoutConstraint]()
//		
//		// TODO: Add constraints
//		constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[view]-|", options: [], metrics: metrics, views: views)
//		
//		NSLayoutConstraint.activateConstraints(constraints)
//	}
//    
//    override class func requiresConstraintBasedLayout() -> Bool {
//        return true
//    }
//}
