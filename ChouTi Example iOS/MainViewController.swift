// Copyright © 2019 ChouTi. All rights reserved.

import ChouTi
import UIKit

class MainViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.view.clipsToBounds = true
        navigationController?.view.layer.cornerRadius = 8.0

        title = "🗄 抽屉(ChouTi)"
        navigationController?.navigationBar.titleTextColor = UIColor(red: 252 / 255.0, green: 43 / 255.0, blue: 27 / 255.0, alpha: 255 / 255.0)
        navigationController?.navigationBar.titleTextFont = UIFont.boldSystemFont(ofSize: 18)

        setupTableView()
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.constrainToFullSizeInSuperview()

        tableView.sections = [
            ViewsSection(),
            ViewControllersSection(),
            MiscellaneousSection(),
            IssuesSection(),
            UITestsSection(),
        ]
    }
}
