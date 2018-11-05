//
//  Issue_PreservesSuperviewLayoutMargins.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-08-17.
//  Copyright © 2016 Honghaoz. All rights reserved.
//

import ChouTi

class Issue_PreservesSuperviewLayoutMargins: UIViewController {

    private let containerView = LayoutMarginView()
    private let subContainerView = LayoutMarginView()
    private let subsubContainerView = LayoutMarginView()
	private let containerViewLayoutMarginsLabel: UILabel = {
		$0.font = UIFont.systemFont(ofSize: 14); return $0
	}(UILabel())

    private lazy var containerView2: LayoutMarginView = self.containerView.viewCopy() as! LayoutMarginView
    private lazy var subContainerView2: LayoutMarginView = self.containerView2.subviewOfType(LayoutMarginView.self)!
    private lazy var subsubContainerView2: LayoutMarginView = self.subContainerView2.subviewOfType(LayoutMarginView.self)!
    private lazy var containerViewLayoutMarginsLabel2: UILabel = self.containerViewLayoutMarginsLabel.viewCopy() as! UILabel

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        title = "preservesSuperviewLayoutMargins"

        // Container for `preservesSuperviewLayoutMargins = false`
        containerView.backgroundColor = ColorPalette.texasRoseYellowColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.layer.cornerRadius = 8.0
        containerView.constrainTo(width: 300, height: 200)

        //
        subContainerView.preservesSuperviewLayoutMargins = false // default value
        subContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subContainerView)

        subContainerView.backgroundColor = UIColor(red: 0.31, green: 0.76, blue: 0.63, alpha: 0.80)
        subContainerView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        subContainerView.constrain(.top, equalTo: .top, ofView: containerView, constant: 30)
        subContainerView.constrain(.leading, equalTo: .leading, ofView: containerView, constant: 30)
        subContainerView.constrain(.bottom, equalTo: .bottom, ofView: containerView, constant: -30)
        subContainerView.constrain(.trailing, equalTo: .trailing, ofView: containerView, constant: -30)

        let descriptionLabel = UILabel()
        descriptionLabel.text = "greenView.preservesSuperviewLayoutMargins = false"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        descriptionLabel.constrain(.top, equalTo: .bottom, ofView: containerView, constant: 8)
        descriptionLabel.constrain(.centerX, toView: containerView)

        containerViewLayoutMarginsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerViewLayoutMarginsLabel.font = UIFont.systemFont(ofSize: 14)
        containerView.addSubview(containerViewLayoutMarginsLabel)
        containerViewLayoutMarginsLabel.constrain(.top, toView: containerView, constant: 8)
        containerViewLayoutMarginsLabel.constrain(.leading, toView: containerView, constant: 8)
        containerViewLayoutMarginsLabel.constrain(.trailing, toView: containerView)
        updateContainerViewLayoutMarginsLabel(containerView)

        subsubContainerView.preservesSuperviewLayoutMargins = true
        subsubContainerView.translatesAutoresizingMaskIntoConstraints = false
        subContainerView.addSubview(subsubContainerView)
        subsubContainerView.backgroundColor = UIColor(red: 0.75, green: 0.15, blue: 0.17, alpha: 1.00)
        subsubContainerView.constrain(.top, equalTo: .top, ofView: subContainerView, constant: 32)
        subsubContainerView.constrain(.leading, equalTo: .leading, ofView: subContainerView, constant: 32)
        subsubContainerView.constrain(.bottom, equalTo: .bottom, ofView: subContainerView, constant: -32)
        subsubContainerView.constrain(.trailing, equalTo: .trailing, ofView: subContainerView, constant: -32)

        // Container for `preservesSuperviewLayoutMargins = true`
        containerView2.translatesAutoresizingMaskIntoConstraints = false
		containerView2.layer.cornerRadius = 8.0
        containerView2.constrainTo(width: 300, height: 200)

        //
        subContainerView2.preservesSuperviewLayoutMargins = true
        subContainerView2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.addSubview(subContainerView2)
        subContainerView2.constrain(.top, equalTo: .top, ofView: containerView2, constant: 30)
        subContainerView2.constrain(.leading, equalTo: .leading, ofView: containerView2, constant: 30)
        subContainerView2.constrain(.bottom, equalTo: .bottom, ofView: containerView2, constant: -30)
        subContainerView2.constrain(.trailing, equalTo: .trailing, ofView: containerView2, constant: -30)

        let descriptionLabel2 = descriptionLabel.viewCopy() as! UILabel
        descriptionLabel2.text = "greenView2.preservesSuperviewLayoutMargins = true"
        descriptionLabel2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.addSubview(descriptionLabel2)
        descriptionLabel2.constrain(.top, equalTo: .bottom, ofView: containerView2, constant: 8)
        descriptionLabel2.constrain(.centerX, toView: containerView2)

        containerViewLayoutMarginsLabel2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.addSubview(containerViewLayoutMarginsLabel2)
        containerViewLayoutMarginsLabel2.constrain(.top, toView: containerView2, constant: 8)
        containerViewLayoutMarginsLabel2.constrain(.leading, toView: containerView2, constant: 8)
        containerViewLayoutMarginsLabel2.constrain(.trailing, toView: containerView2)
        updateContainerViewLayoutMarginsLabel(containerView2)

        subsubContainerView2.removeFromSuperview()

        let stackView = UIStackView(arrangedSubviews: [containerView, containerView2])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 64

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.constrainToCenterInSuperview()

        shrink(containerView)
        shrink(containerView2)
    }

    private func shrink(_ view: UIView) {
        delay(2) {
            view.layoutMargins = UIEdgeInsets(
                top: CGFloat.random(in: 0...100),
                left: CGFloat.random(in: 0...150),
                bottom: CGFloat.random(in: 0...100),
                right: CGFloat.random(in: 0...150)
            )
            self.updateContainerViewLayoutMarginsLabel(view)
            UIView.animate(withDuration: 1.0, animations: {
                view.layoutIfNeeded()
                }, completion: { _ in
                    self.restore(view)
            })
        }
    }

    private func restore(_ view: UIView) {
        delay(2) {
            view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            self.updateContainerViewLayoutMarginsLabel(view)
            UIView.animate(withDuration: 1.0, animations: {
                view.layoutIfNeeded()
                }, completion: { _ in
                    self.shrink(view)
            })
        }
    }

    private func updateContainerViewLayoutMarginsLabel(_ containerView: UIView) {
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

        layoutMarginGuideView.constrain(.top, equalTo: .topMargin, ofView: self)
        layoutMarginGuideView.constrain(.leading, equalTo: .leadingMargin, ofView: self)
        layoutMarginGuideView.constrain(.bottom, equalTo: .bottomMargin, ofView: self)
        layoutMarginGuideView.constrain(.trailing, equalTo: .trailingMargin, ofView: self)

        layoutMarginGuideView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)

        layoutMarginGuideView.addDashedBorderLine(0.5, borderColor: UIColor(white: 0.0, alpha: 0.8), paintedSegmentLength: 2, unpaintedSegmentLength: 2)
        self.addDashedBorderLine(0.5, borderColor: UIColor(white: 0.0, alpha: 1.0), paintedSegmentLength: 3, unpaintedSegmentLength: 3)
    }
}
