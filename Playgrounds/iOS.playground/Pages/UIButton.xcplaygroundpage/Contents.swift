// Copyright © 2019 ChouTi. All rights reserved.

import ChouTi
import UIKit
import XCPlayground

class PlaygroundViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.bounds.size = CGSize(width: 375, height: 667)
    view.backgroundColor = UIColor.whiteColor()

    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)

    // UIButton Code Snippet
    button.clipsToBounds = true
    button.layer.cornerRadius = 8.0

    button.setBackgroundColor(UIColor.blueColor(), forUIControlState: .Normal)
    button.setBackgroundColor(UIColor.blueColor().colorWithAlphaComponent(0.5), forUIControlState: .Highlighted)
    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)

    button.setTitle("Button Title", forState: .Normal)
    button.titleLabel?.font = UIFont.systemFontOfSize(26)
    button.addTarget(self, action: #selector(dynamicType.buttonTapped(_:)), forControlEvents: .TouchUpInside)

    button.centerInSuperview()
    button.constraintToSize(CGSize(width: 200, height: 88))
  }

  func buttonTapped(sender _: AnyObject) {
    print("button tapped")
  }
}

let viewController = PlaygroundViewController()
XCPlaygroundPage.currentPage.liveView = viewController.view
