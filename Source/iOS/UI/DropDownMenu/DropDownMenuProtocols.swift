//
//  DropDownMenuProtocols.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-10.
//
//

import Foundation

public protocol DropDownMenuDataSource : class {
	func numberOfOptionsInDropDownMenu(dropDownMenu: DropDownMenu) -> Int
	func dropDownMenu(dropDownMenu: DropDownMenu, optionTitleForIndex index: Int) -> String
}

public protocol DropDownMenuDelegate : class {
	func dropDownMenu(dropDownMenu: DropDownMenu, didSelectedIndex index: Int)
}
