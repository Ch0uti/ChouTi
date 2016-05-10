import UIKit
import XCPlayground

@available(iOS 9.0, *)
public class AlertView: UIView {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    private let labelsStackView = UIStackView()
    private let actionButtonsStackView = UIStackView()
    private let containerStackView = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        v.backgroundColor = UIColor.greenColor()
        addSubview(v)
        
        // Labels
        titleLabel.text = "Title"
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFontOfSize(18)
        titleLabel.textAlignment = .Center
        titleLabel.setContentHuggingPriority(1000, forAxis: .Vertical)
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        
        messageLabel.text = "Message"
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.textAlignment = .Center
        messageLabel.setContentHuggingPriority(1000, forAxis: .Vertical)
        messageLabel.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        
        labelsStackView.axis = .Vertical
        labelsStackView.distribution = .EqualSpacing
        labelsStackView.spacing = 8.0
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(messageLabel)
        
        labelsStackView.backgroundColor = UIColor.blueColor()
        
        // Action Buttons
        actionButtonsStackView.axis = .Horizontal
        actionButtonsStackView.distribution = .FillEqually
        actionButtonsStackView.hidden = true // there's no actions, set to hidden by default
        
        // Container
        containerStackView.axis = .Vertical
        containerStackView.distribution = .EqualSpacing
        containerStackView.spacing = 16.0
        
        containerStackView.addArrangedSubview(labelsStackView)
        containerStackView.addArrangedSubview(actionButtonsStackView)
        
        containerStackView.backgroundColor = UIColor.redColor()
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
    }
    
    private func setupConstraints() {
        let views = [
            "containerStackView" : containerStackView
        ]
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerStackView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerStackView]|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    public func addAction() {
        
    }
}

let alertView = AlertView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))


alertView

//class PlaygroundViewController: UIViewController {
//    
//    var alertController: UIAlertController!
//    
//    // Container View height is determined by bigger labels
//    let containerView = UIView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.bounds.size = CGSize(width: 375, height: 667)
//        view.backgroundColor = UIColor.whiteColor()
//        
//        setupViews()
//        setupConstraints()
//    }
//    
//    func setupViews() {
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PlaygroundViewController.viewTapped(_:)))
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    func setupConstraints() {
////        containerView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
////        
////        var constraints = [NSLayoutConstraint]()
////        
////        let views = [
////            "leftLabel" : leftLabel,
////            "rightLabel" : rightLabel,
////            "containerView" : containerView
////        ]
////        
////        if #available(iOS 9.0, *) {
////            [leftLabel, rightLabel].forEach {
////                $0.topAnchor.constraintGreaterThanOrEqualToAnchor(containerView.layoutMarginsGuide.topAnchor).active = true
////                $0.bottomAnchor.constraintLessThanOrEqualToAnchor(containerView.layoutMarginsGuide.bottomAnchor).active = true
////                
////                $0.setContentHuggingPriority(1000, forAxis: .Vertical)
////                $0.setContentHuggingPriority(1000, forAxis: .Horizontal)
////            }
////        } else {
////            [leftLabel, rightLabel].forEach {
////                NSLayoutConstraint(item: $0, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: containerView, attribute: .TopMargin, multiplier: 1.0, constant: 0.0).active = true
////                NSLayoutConstraint(item: $0, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: containerView, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0).active = true
////                
////                $0.setContentHuggingPriority(1000, forAxis: .Vertical)
////                $0.setContentHuggingPriority(1000, forAxis: .Horizontal)
////            }
////        }
////        
////        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-[leftLabel]-(>=8)-[rightLabel]-|", options: [.AlignAllBaseline], metrics: nil, views: views)
////        
////        // For Container
////        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[containerView]-50-|", options: [], metrics: nil, views: views)
////        constraints.append(
////            containerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
////        )
////        
////        NSLayoutConstraint.activateConstraints(constraints)
//    }
//    
//    func viewTapped(sender: AnyObject) {
//        print("tapped")
//        
//        self.presentViewController(alertController, animated: true) {
//            // ...
//        }
//    }
//}
//
//let viewController = PlaygroundViewController()
//XCPlaygroundPage.currentPage.liveView = viewController.view
