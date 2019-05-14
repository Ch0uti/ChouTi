// Copyright © 2019 ChouTi. All rights reserved.

import ChouTi
import UIKit

class LeadingTrailingVSLeftRightDemoViewController: UIViewController {
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
        label1.text = "Leading/Trailing"
        stackView.addArrangedSubview(label1)

        let container1 = UIView()
        container1.translatesAutoresizingMaskIntoConstraints = false
        container1.constrainTo(width: 240, height: 60)
        stackView.addArrangedSubview(container1)
        container1.layer.borderWidth = 0.5
        container1.layer.borderColor = UIColor.black.cgColor

        setupLabelsWithLeadingTrailingConstraints(container1)

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.text = "Left/Right"
        stackView.addArrangedSubview(label2)

        let container2 = UIView()
        container2.translatesAutoresizingMaskIntoConstraints = false
        container2.constrainTo(width: 240, height: 60)
        stackView.addArrangedSubview(container2)
        container2.layer.borderWidth = 0.5
        container2.layer.borderColor = UIColor.black.cgColor

        setupLabelsWithLeftRightConstraints(container2)

        stackView.constrainToCenterInSuperview()
    }

    func setupLabelsWithLeadingTrailingConstraints(_ container: UIView) {
        container.layoutMargins.left = 16
        container.layoutMargins.right = 32

        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label1)
        label1.text = "Hello"
        label1.textColor = .white
        label1.backgroundColor = UIColor.red

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label2)
        label2.text = "World"
        label2.textColor = .white
        label2.backgroundColor = UIColor.blue

        label1.centerYAnchor.constraint(equalTo: container.centerYAnchor).activate()
        label2.centerYAnchor.constraint(equalTo: container.centerYAnchor).activate()

        label1.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor).activate()
        label2.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 16).activate()
        label2.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor).activate()
    }

    func setupLabelsWithLeftRightConstraints(_ container: UIView) {
        container.layoutMargins.left = 16
        container.layoutMargins.right = 32

        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label1)
        label1.text = "Hello"
        label1.textColor = .white
        label1.backgroundColor = UIColor.red

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label2)
        label2.text = "World"
        label2.textColor = .white
        label2.backgroundColor = UIColor.blue

        label1.centerYAnchor.constraint(equalTo: container.centerYAnchor).activate()
        label2.centerYAnchor.constraint(equalTo: container.centerYAnchor).activate()

        label1.leftAnchor.constraint(equalTo: container.layoutMarginsGuide.leftAnchor).activate()
        label2.leftAnchor.constraint(equalTo: label1.rightAnchor, constant: 16).activate()
        label2.rightAnchor.constraint(equalTo: container.layoutMarginsGuide.rightAnchor).activate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.keyWindow?.applySemanticContentAttribute(.forceRightToLeft)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIApplication.shared.keyWindow?.applySemanticContentAttribute(.forceLeftToRight)
    }
}

private extension UIView {
    func applySemanticContentAttribute(_ attribute: UISemanticContentAttribute) {
        if subviews.isEmpty == false {
            subviews.forEach { $0.applySemanticContentAttribute(attribute) }
        }

        semanticContentAttribute = attribute
    }
}
