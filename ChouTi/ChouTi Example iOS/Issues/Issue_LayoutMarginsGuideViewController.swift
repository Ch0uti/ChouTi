//
//  Issue_LayoutMarginsGuideViewController.swift
//  ChouTi iOS Example
//
//  Created by Honghao Zhang on 2016-07-05.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import UIKit
import ChouTi

class Issue_LayoutMarginsGuideViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupViews()
    }
    
    func setupViews() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.text = "Use Anchor"
        label1.textColor = .white
        label1.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        
        stackView.addArrangedSubview(label1.wrappedInView(useAnchor: true))
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.text = "Use NSLayoutConstaintAPI"
        label2.textColor = .white
        label2.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        
        stackView.addArrangedSubview(label2.wrappedInView(useAnchor: false))
        
        stackView.constrainToCenterInSuperview()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.text = "layoutMarginsGuide.leadingAnchor"
        label3.textColor = .white
        label3.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        view.addSubview(label3)
        
        label3.leadingAnchor.constraint(equalTo: label2.superview!.layoutMarginsGuide.leadingAnchor).activate()
        label3.topAnchor.constraint(equalTo: label2.superview!.bottomAnchor, constant: 20).activate()
    }
}

private extension UIView {
    func wrappedInView(useAnchor: Bool) -> UIView {
        let wrapperView = UIView()
        wrapperView.layoutMargins = UIEdgeInsets(top: 16, left: 32, bottom: 8, right: 8)
        wrapperView.addSubview(self)
        wrapperView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        wrapperView.addDashedBorderLine(0.5, borderColor: .black, paintedSegmentLength: 2, unpaintedSegmentLength: 2)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if useAnchor {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: wrapperView.layoutMarginsGuide.topAnchor),
                self.leadingAnchor.constraint(equalTo: wrapperView.layoutMarginsGuide.leadingAnchor),
                self.bottomAnchor.constraint(equalTo: wrapperView.layoutMarginsGuide.bottomAnchor),
                self.trailingAnchor.constraint(equalTo: wrapperView.layoutMarginsGuide.trailingAnchor)
                ])
        } else {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: wrapperView, attribute: .topMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: wrapperView, attribute: .leadingMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: wrapperView, attribute: .bottomMargin, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: wrapperView, attribute: .trailingMargin, multiplier: 1.0, constant: 0.0)
                ]
            )
        }
        return wrapperView
    }
}
