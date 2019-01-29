// Copyright © 2019 ChouTi. All rights reserved.

import ChouTi
import UIKit

class TableLayoutDemoViewController: UIViewController {
    let doneButton = Button(type: .system)

    let columns = Int.random(in: 5...20)
    var rows = [Int: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //		view.backgroundColor = UIColor.white
        //		title = "Table Layout"
        //
        //		for c in 0 ..< columns {
        //			rows[c] = Int.random(1, 30)
        //		}
        //
        //		let excelTable = TextTableCollectionView()
        //		excelTable.textTableDataSource = self
        //		excelTable.separatorLineWidth = 0.5
        //      excelTable.layer.borderColor = UIColor.black.cgColor
        //      excelTable.layer.borderWidth = 0.5
        //
        //		excelTable.translatesAutoresizingMaskIntoConstraints = false
        //		view.addSubview(excelTable)
        //
        //		doneButton.translatesAutoresizingMaskIntoConstraints = false
        //		doneButton.setTitle("Done", for: .normal)
        //		doneButton.setTitleColor(UIColor.blue, for: .normal)
        //		doneButton.addTarget(self, action: #selector(TableLayoutDemoViewController.doneButtonPressed(_:)), for: .touchUpInside)
        //		view.addSubview(doneButton)
        //
        //		let views = ["excelTable": excelTable, "doneButton": doneButton]
        //		var constraints = [NSLayoutConstraint]()
        //
        //		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[excelTable]-|", options: [], metrics: nil, views: views)
        //		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[excelTable]-16-|", options: [], metrics: nil, views: views)
        //
        //		constraints.append(doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        //		constraints.append(doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40))
        //
        //		NSLayoutConstraint.activate(constraints)
    }

    func doneButtonPressed(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension TableLayoutDemoViewController: TextTableCollectionViewDataSource {
    func numberOfColumnsInTableCollectionView(_: TextTableCollectionView) -> Int {
        return columns
    }

    func tableCollectionView(_: TextTableCollectionView, numberOfRowsInColumn column: Int) -> Int {
        return rows[column]!
    }

    func tableCollectionView(_: TextTableCollectionView, layout _: TableCollectionViewLayout, titleForColumn column: Int) -> String {
        return "Title: \(column)"
    }

    func tableCollectionView(_: TextTableCollectionView, layout _: TableCollectionViewLayout, contentForColumn column: Int, row: Int) -> String {
        return "Content: (\(row),\(column))"
    }
}
