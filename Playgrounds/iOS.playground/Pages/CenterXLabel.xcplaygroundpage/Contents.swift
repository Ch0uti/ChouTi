import UIKit
import XCPlayground

class PlaygroundViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bounds.size = CGSize(width: 375, height: 667)
        view.backgroundColor = UIColor.whiteColor()
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.font = UIFont.systemFontOfSize(18)
        label.textColor = UIColor.darkTextColor()
        label.text = "Label"
        label.backgroundColor = UIColor.yellowColor()
    }
    
    func setupConstraints() {
        NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0).active = true
        NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 100.0).active = true
    }
}

let viewController = PlaygroundViewController()
XCPlaygroundPage.currentPage.liveView = viewController.view
