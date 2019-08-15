// Copyright © 2019 ChouTi. All rights reserved.

import UIKit
import XCPlayground

class PlaygroundViewController: UIViewController {
  let leftLabel = UILabel()
  let rightLabel = UILabel()

  // Container View height is determined by bigger labels
  let containerView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.bounds.size = CGSize(width: 375, height: 667)
    view.backgroundColor = UIColor.whiteColor()

    setupViews()
    setupConstraints()
  }

  func setupViews() {
    leftLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(leftLabel)
    leftLabel.font = UIFont.systemFontOfSize(18)
    leftLabel.textColor = UIColor.darkTextColor()
    leftLabel.text = "Left"
    leftLabel.backgroundColor = UIColor.greenColor()

    rightLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(rightLabel)
    rightLabel.font = UIFont.systemFontOfSize(56)
    rightLabel.textColor = UIColor.darkTextColor()
    rightLabel.text = "Right"
    rightLabel.backgroundColor = UIColor.greenColor()

    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.backgroundColor = UIColor.yellowColor()
    view.addSubview(containerView)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PlaygroundViewController.adjustLabelFont(_:)))
    view.addGestureRecognizer(tapGesture)
  }

  func setupConstraints() {
    containerView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    var constraints = [NSLayoutConstraint]()

    let views = [
      "leftLabel": leftLabel,
      "rightLabel": rightLabel,
      "containerView": containerView,
    ]

    if #available(iOS 9.0, *) {
      [leftLabel, rightLabel].forEach {
        $0.topAnchor.constraintGreaterThanOrEqualToAnchor(containerView.layoutMarginsGuide.topAnchor).active = true
        $0.bottomAnchor.constraintLessThanOrEqualToAnchor(containerView.layoutMarginsGuide.bottomAnchor).active = true

        $0.setContentHuggingPriority(1000, forAxis: .Vertical)
        $0.setContentHuggingPriority(1000, forAxis: .Horizontal)
      }
    } else {
      [leftLabel, rightLabel].forEach {
        NSLayoutConstraint(item: $0, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: containerView, attribute: .TopMargin, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: $0, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: containerView, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0).active = true

        $0.setContentHuggingPriority(1000, forAxis: .Vertical)
        $0.setContentHuggingPriority(1000, forAxis: .Horizontal)
      }
    }

    constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[leftLabel]-(>=8)-[rightLabel]-|", options: [.AlignAllBaseline], metrics: nil, views: views)

    // For Container
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[containerView]-50-|", options: [], metrics: nil, views: views)
    constraints.append(
      containerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
    )

    NSLayoutConstraint.activateConstraints(constraints)
  }

  func adjustLabelFont(sender _: AnyObject) {
    leftLabel.font = leftLabel.font.fontWithSize(CGFloat.random(14, 60))
    rightLabel.font = rightLabel.font.fontWithSize(CGFloat.random(14, 60))
  }
}

let viewController = PlaygroundViewController()
XCPlaygroundPage.currentPage.liveView = viewController.view

public extension CGFloat {
  /**
   Get a random CGFloat number

   - parameter lower: lower number, inclusive
   - parameter upper: upper number, inclusive

   - returns: a random number
   */
  static func random(lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
  }
}
