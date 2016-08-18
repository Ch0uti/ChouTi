//
//  Issue_PreservesSuperviewLayoutMargins.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-17.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import ChouTi
import Then

class Issue_PreservesSuperviewLayoutMargins: UIViewController {
    
    private let containerView = LayoutMarginView()
    private let subContainerView = LayoutMarginView()
    private let containerViewLayoutMarginsLabel = UILabel().then { $0.font = UIFont.systemFontOfSize(14) }
    
    private lazy var containerView2: LayoutMarginView = self.containerView.viewCopy() as! LayoutMarginView
    private lazy var subContainerView2: LayoutMarginView = self.subContainerView.viewCopy() as! LayoutMarginView
    private lazy var containerViewLayoutMarginsLabel2: UILabel = self.containerViewLayoutMarginsLabel.viewCopy() as! UILabel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        title = "preservesSuperviewLayoutMargins"
        
        // Container for `preservesSuperviewLayoutMargins = false`
        containerView.backgroundColor = UIColor(red:0.9922, green:0.6784, blue:0.0392, alpha:1.0)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.constrainTo(width: 300, height: 200)
        
        //
        subContainerView.preservesSuperviewLayoutMargins = false // default value
        subContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subContainerView)
        
        subContainerView.backgroundColor = UIColor(red:0.31, green:0.76, blue:0.63, alpha:1.00)
        subContainerView.constrain(.Top, equalTo: .Top, ofView: containerView, constant: 4)
        subContainerView.constrain(.Leading, equalTo: .Leading, ofView: containerView, constant: 4)
        subContainerView.constrain(.Bottom, equalTo: .Bottom, ofView: containerView, constant: -4)
        subContainerView.constrain(.Trailing, equalTo: .Trailing, ofView: containerView, constant: -4)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "greenView.preservesSuperviewLayoutMargins = false"
        descriptionLabel.font = UIFont.systemFontOfSize(14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        descriptionLabel.constrain(.Top, equalTo: .Bottom, ofView: containerView, constant: 8)
        descriptionLabel.constrain(.CenterX, toView: containerView)
        
        containerViewLayoutMarginsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerViewLayoutMarginsLabel.font = UIFont.systemFontOfSize(14)
        containerView.addSubview(containerViewLayoutMarginsLabel)
        containerViewLayoutMarginsLabel.constrain(.Top, toView: containerView, constant: 8)
        containerViewLayoutMarginsLabel.constrain(.Leading, toView: containerView, constant: 8)
        containerViewLayoutMarginsLabel.constrain(.Trailing, toView: containerView)
        updateContainerViewLayoutMarginsLabel(containerView)
        
        // Container for `preservesSuperviewLayoutMargins = true`
        containerView2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.constrainTo(width: 300, height: 200)
        
        //
        subContainerView2.preservesSuperviewLayoutMargins = true
        subContainerView2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.addSubview(subContainerView2)
        subContainerView2.constrain(.Top, equalTo: .Top, ofView: containerView2, constant: 4)
        subContainerView2.constrain(.Leading, equalTo: .Leading, ofView: containerView2, constant: 4)
        subContainerView2.constrain(.Bottom, equalTo: .Bottom, ofView: containerView2, constant: -4)
        subContainerView2.constrain(.Trailing, equalTo: .Trailing, ofView: containerView2, constant: -4)
        
        let descriptionLabel2 = descriptionLabel.viewCopy() as! UILabel
        descriptionLabel2.text = "greenView2.preservesSuperviewLayoutMargins = true"
        descriptionLabel2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.addSubview(descriptionLabel2)
        descriptionLabel2.constrain(.Top, equalTo: .Bottom, ofView: containerView2, constant: 8)
        descriptionLabel2.constrain(.CenterX, toView: containerView2)
        
        containerViewLayoutMarginsLabel2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.addSubview(containerViewLayoutMarginsLabel2)
        containerViewLayoutMarginsLabel2.constrain(.Top, toView: containerView2, constant: 8)
        containerViewLayoutMarginsLabel2.constrain(.Leading, toView: containerView2, constant: 8)
        containerViewLayoutMarginsLabel2.constrain(.Trailing, toView: containerView2)
        updateContainerViewLayoutMarginsLabel(containerView2)
        
        let stackView = UIStackView(arrangedSubviews: [containerView, containerView2])
        stackView.axis = .Vertical
        stackView.alignment = .Center
        stackView.distribution = .EqualSpacing
        stackView.spacing = 64
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.constrainToCenterInSuperview()
        
        shrink(containerView)
        shrink(containerView2)
    }
    
    private func shrink(view: UIView) {
        delay(2) {
            view.layoutMargins = UIEdgeInsets(
                top: CGFloat.random(0, 100),
                left: CGFloat.random(0, 150),
                bottom: CGFloat.random(0, 100),
                right: CGFloat.random(0, 150)
            )
            self.updateContainerViewLayoutMarginsLabel(view)
            UIView.animateWithDuration(1.0, animations: {
                view.layoutIfNeeded()
                }, completion: { _ in
                    self.restore(view)
            })
        }
    }
    
    private func restore(view: UIView) {
        delay(2) {
            view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            self.updateContainerViewLayoutMarginsLabel(view)
            UIView.animateWithDuration(1.0, animations: {
                view.layoutIfNeeded()
                }, completion: { _ in
                    self.shrink(view)
            })
        }
    }
    
    private func updateContainerViewLayoutMarginsLabel(containerView: UIView) {
        let text = String(format: "yellowView: (%.1f, %.1f, %.1f, %.1f)", containerView.layoutMargins.top, containerView.layoutMargins.left, containerView.layoutMargins.bottom, containerView.layoutMargins.right)
        if containerView === self.containerView {
            containerViewLayoutMarginsLabel.text = text
        } else if containerView === self.containerView2 {
            containerViewLayoutMarginsLabel2.text = text
        }
    }
}

private class LayoutMarginView: UIView {
    final let layoutMarginGuideView = UIView()
    private final let dashlineLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private final func commonInit() {
        layoutMarginGuideView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(layoutMarginGuideView)
        
        layoutMarginGuideView.constrain(.Top, equalTo: .TopMargin, ofView: self)
        layoutMarginGuideView.constrain(.Leading, equalTo: .LeadingMargin, ofView: self)
        layoutMarginGuideView.constrain(.Bottom, equalTo: .BottomMargin, ofView: self)
        layoutMarginGuideView.constrain(.Trailing, equalTo: .TrailingMargin, ofView: self)

        layoutMarginGuideView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        
        layoutMarginGuideView.addDashedBorderLine(0.5, borderColor: UIColor(white: 0.0, alpha: 0.8), paintedSegmentLength: 2, unpaintedSegmentLength: 2)
        self.addDashedBorderLine(0.5, borderColor: UIColor(white: 0.0, alpha: 1.0), paintedSegmentLength: 3, unpaintedSegmentLength: 3)
    }
}
