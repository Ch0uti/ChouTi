//
//  IssueLayoutMarginsGuideViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-07-05.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit
import ChouTi

class IssueLayoutMarginsGuideViewController: UIViewController {
    
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
        label1.text = "Use Anchor"
        label1.textColor = .whiteColor()
        label1.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.4)
        
        stackView.addArrangedSubview(label1.wrappedInView(useAnchor: true))
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.text = "Use NSLayoutConstaintAPI"
        label2.textColor = .whiteColor()
        label2.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.4)
        
        stackView.addArrangedSubview(label2.wrappedInView(useAnchor: false))
        
        stackView.constrainToCenterInSuperview()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.text = "layoutMarginsGuide.leadingAnchor"
        label3.textColor = .whiteColor()
        label3.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.4)
        view.addSubview(label3)
        
        label3.leadingAnchor.constraintEqualToAnchor(label2.superview!.layoutMarginsGuide.leadingAnchor).activate()
        label3.topAnchor.constraintEqualToAnchor(label2.superview!.bottomAnchor, constant: 20).activate()
    }
}

private extension UIView {
    private func wrappedInView(useAnchor useAnchor: Bool) -> UIView {
        let wrapperView = UIView()
        wrapperView.layoutMargins = UIEdgeInsets(top: 16, left: 32, bottom: 8, right: 8)
        wrapperView.addSubview(self)
        wrapperView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if useAnchor {
            NSLayoutConstraint.activateConstraints([
                self.topAnchor.constraintEqualToAnchor(wrapperView.layoutMarginsGuide.topAnchor),
                self.leadingAnchor.constraintEqualToAnchor(wrapperView.layoutMarginsGuide.leadingAnchor),
                self.bottomAnchor.constraintEqualToAnchor(wrapperView.layoutMarginsGuide.bottomAnchor),
                self.trailingAnchor.constraintEqualToAnchor(wrapperView.layoutMarginsGuide.trailingAnchor)
                ])
        } else {
            NSLayoutConstraint.activateConstraints([
                NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: wrapperView, attribute: .TopMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: wrapperView, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: wrapperView, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: wrapperView, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0)
                ]
            )
        }
        return wrapperView
    }
}
