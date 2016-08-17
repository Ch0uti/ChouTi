//
//  LeadingTrailingVSLeftRightDemoViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-07-05.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit
import ChouTi

class LeadingTrailingVSLeftRightDemoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupViews()
    }
    
    func setupViews() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.alignment = .Center
        stackView.spacing = 16.0
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.text = "Leading/Trailing"
        stackView.addArrangedSubview(label1)
        
        let container1 = UIView()
        container1.translatesAutoresizingMaskIntoConstraints = false
        container1.constrainTo(width: 240, height: 60)
        stackView.addArrangedSubview(container1)
        container1.layer.borderWidth = 0.5
        container1.layer.borderColor = UIColor.blackColor().CGColor
        
        setupLabelsWithLeadingTrailingConstraints(container1)
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.text = "Left/Right"
        stackView.addArrangedSubview(label2)
        
        let container2 = UIView()
        container2.translatesAutoresizingMaskIntoConstraints = false
        container2.constrainTo(width: 240, height: 60)
        stackView.addArrangedSubview(container2)
        container2.layer.borderWidth = 0.5
        container2.layer.borderColor = UIColor.blackColor().CGColor
        
        setupLabelsWithLeftRightConstraints(container2)
        
        stackView.constrainToCenterInSuperview()
    }
    
    func setupLabelsWithLeadingTrailingConstraints(container: UIView) {
        container.layoutMargins.left = 16
        container.layoutMargins.right = 32
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label1)
        label1.text = "Hello"
        label1.textColor = .whiteColor()
        label1.backgroundColor = UIColor.redColor()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label2)
        label2.text = "World"
        label2.textColor = .whiteColor()
        label2.backgroundColor = UIColor.blueColor()
        
        label1.centerYAnchor.constraintEqualToAnchor(container.centerYAnchor).activate()
        label2.centerYAnchor.constraintEqualToAnchor(container.centerYAnchor).activate()
        
        label1.leadingAnchor.constraintEqualToAnchor(container.layoutMarginsGuide.leadingAnchor).activate()
        label2.leadingAnchor.constraintEqualToAnchor(label1.trailingAnchor, constant: 16).activate()
        label2.trailingAnchor.constraintEqualToAnchor(container.layoutMarginsGuide.trailingAnchor).activate()
    }
    
    func setupLabelsWithLeftRightConstraints(container: UIView) {
        container.layoutMargins.left = 16
        container.layoutMargins.right = 32
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label1)
        label1.text = "Hello"
        label1.textColor = .whiteColor()
        label1.backgroundColor = UIColor.redColor()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label2)
        label2.text = "World"
        label2.textColor = .whiteColor()
        label2.backgroundColor = UIColor.blueColor()
        
        label1.centerYAnchor.constraintEqualToAnchor(container.centerYAnchor).activate()
        label2.centerYAnchor.constraintEqualToAnchor(container.centerYAnchor).activate()
        
        label1.leftAnchor.constraintEqualToAnchor(container.layoutMarginsGuide.leftAnchor).activate()
        label2.leftAnchor.constraintEqualToAnchor(label1.rightAnchor, constant: 16).activate()
        label2.rightAnchor.constraintEqualToAnchor(container.layoutMarginsGuide.rightAnchor).activate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().keyWindow?.applySemanticContentAttribute(.ForceRightToLeft)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().keyWindow?.applySemanticContentAttribute(.ForceLeftToRight)
    }
}

private extension UIView {
    private func applySemanticContentAttribute(attribute: UISemanticContentAttribute) {
        if subviews.isEmpty == false {
            subviews.forEach { $0.applySemanticContentAttribute(attribute) }
        }
        
        self.semanticContentAttribute = attribute
    }
}
