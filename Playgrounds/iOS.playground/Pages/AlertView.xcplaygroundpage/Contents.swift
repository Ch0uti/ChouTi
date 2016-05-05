import UIKit
import XCPlayground

class AlertView {
    
}



class PlaygroundViewController: UIViewController {
    
    var alertController: UIAlertController!
    
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
        alertController = UIAlertController(title: "Default Style", message: "A standard alert.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { action in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
            // ...
        }
        alertController.addAction(OKAction)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PlaygroundViewController.viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
//        containerView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        
//        var constraints = [NSLayoutConstraint]()
//        
//        let views = [
//            "leftLabel" : leftLabel,
//            "rightLabel" : rightLabel,
//            "containerView" : containerView
//        ]
//        
//        if #available(iOS 9.0, *) {
//            [leftLabel, rightLabel].forEach {
//                $0.topAnchor.constraintGreaterThanOrEqualToAnchor(containerView.layoutMarginsGuide.topAnchor).active = true
//                $0.bottomAnchor.constraintLessThanOrEqualToAnchor(containerView.layoutMarginsGuide.bottomAnchor).active = true
//                
//                $0.setContentHuggingPriority(1000, forAxis: .Vertical)
//                $0.setContentHuggingPriority(1000, forAxis: .Horizontal)
//            }
//        } else {
//            [leftLabel, rightLabel].forEach {
//                NSLayoutConstraint(item: $0, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: containerView, attribute: .TopMargin, multiplier: 1.0, constant: 0.0).active = true
//                NSLayoutConstraint(item: $0, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: containerView, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0).active = true
//                
//                $0.setContentHuggingPriority(1000, forAxis: .Vertical)
//                $0.setContentHuggingPriority(1000, forAxis: .Horizontal)
//            }
//        }
//        
//        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[leftLabel]-(>=8)-[rightLabel]-|", options: [.AlignAllBaseline], metrics: nil, views: views)
//        
//        // For Container
//        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[containerView]-50-|", options: [], metrics: nil, views: views)
//        constraints.append(
//            containerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
//        )
//        
//        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func viewTapped(sender: AnyObject) {
        print("tapped")
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
}

let viewController = PlaygroundViewController()
XCPlaygroundPage.currentPage.liveView = viewController.view
