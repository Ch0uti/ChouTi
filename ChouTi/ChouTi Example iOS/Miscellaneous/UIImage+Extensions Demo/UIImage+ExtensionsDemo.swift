// Copyright © 2019 ChouTi. All rights reserved.

import ChouTi
import UIKit

class UIImageExtensionsDemoViewController: UIViewController {
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "UIImage+Extensions Demo"

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.constrainToFullSizeInSuperview()

        tableView.sections = [
            TableViewSection(rows: [
                TableViewRow(
                    title: "UIImage+CroppedImage",
                    cellSelectAction: { [weak self] indexPath, _, _ in
                        self?.tableView.deselectRow(at: indexPath, animated: true)
                        let demoViewController = UIImage_CroppedImageDemoViewController()
                        self?.show(demoViewController, sender: nil)
                    }
                ),
                TableViewRow(
                    title: "UIImage+AnimatingImages", subtitle: "Sprite in UIKit",
                    cellSelectAction: { [weak self] indexPath, _, _ in
                        self?.tableView.deselectRow(at: indexPath, animated: true)
                        let demoViewController = UIImage_AnimatingImagesDemoViewController()
                        self?.show(demoViewController, sender: nil)
                    }
                ),
            ]),
        ]
    }
}
