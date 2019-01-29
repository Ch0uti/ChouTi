// Copyright © 2019 ChouTi. All rights reserved.

import PlaygroundSupport
import UIKit

let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
view.backgroundColor = .white
view.isUserInteractionEnabled = true
PlaygroundPage.current.liveView = view

let scrollView = UIScrollView()
scrollView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
scrollView.backgroundColor = .yellow
view.addSubview(scrollView)
scrollView.isUserInteractionEnabled = true

// contentInset.top affects below refreshView.frame
scrollView.contentInset.top = 10

print(scrollView.bounds)

let refreshView = UIView()
refreshView.backgroundColor = .red
refreshView.frame = CGRect(x: 0, y: -20, width: 375, height: 20)
scrollView.addSubview(refreshView)
