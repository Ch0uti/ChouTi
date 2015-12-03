//
//  TableView+Sections.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import UIKit

public extension UITableView {
	private struct zhSectionsKey {
		static var Key = "zhSectionsKey"
	}
	
	// https://wezzard.com/2015/10/09/associated-object-and-swift-struct/
	public var sections: [TableViewSectionType]? {
		get {
			let object = objc_getAssociatedObject(self, &zhSectionsKey.Key)
			return StructWrapper<[TableViewSectionType]>.structFromObject(object)
		}
		
		set {
			let object = StructWrapper<[TableViewSectionType]>.objectFromStruct(newValue)
			objc_setAssociatedObject(self, &zhSectionsKey.Key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			if dataSource == nil {
				dataSource = self
			}
			
			if delegate == nil {
				delegate = self
			}
		}
	}
}



// MARK: - TableView DataSource Methods
extension UITableView : UITableViewDataSource {
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return sections?.count ?? 0
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let section = sectionForIndex(section) else {
			print("warning: no sections in \(self)")
			return 0
		}
		
		return section.rows.count
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let row = rowForIndexPath(indexPath) else {
			print("row not found")
			return UITableViewCell()
		}
		
		var cell: UITableViewCell! = nil
		
		if let cellConfiguration = row.cellInitialization {
			cell = cellConfiguration(indexPath)
		} else {
			cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier())
			
			if cell == nil {
				cell = TableViewCell(style: .Subtitle, reuseIdentifier: TableViewCell.identifier())
			}
		}
		
		tableView.tableView(tableView, cellConfigurationForCell: cell, atIndexPath: indexPath)
		
		return cell
	}
	
	public func tableView(tableView: UITableView, cellConfigurationForCell cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		guard let row = rowForIndexPath(indexPath) else {
			print("row not found")
			return
		}
		
		row.cellConfiguration?(cell)
	}
	
	public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		guard let sections = sections else {
			print("warning: no sections in \(self)")
			return nil
		}
		
		// If there's no one section wants show index, return nil
		if sections.filter({ $0.shouldShowIndex }).count == 0 {
			return nil
		}
		
		return sections.map { $0.shouldShowIndex ? ($0.headerTitle ?? "") : "" }
	}
	
	public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let section = sectionForIndex(section) else {
			print("warning: no sections in \(self)")
			return nil
		}
		
		return section.headerTitle
	}
	
	public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		guard let section = sectionForIndex(section) else {
			print("warning: no sections in \(self)")
			return nil
		}
		
		return section.footerTitle
	}
}


// MARK: - TableView Delegate Methods
extension UITableView : UITableViewDelegate {
	public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		guard let row = rowForIndexPath(indexPath) else {
			print("row not found")
			return
		}
		
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		row.cellSelectAction?(indexPath: indexPath, cell: cell)
	}
	
	public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		guard let row = rowForIndexPath(indexPath) else {
			print("row not found")
			return
		}
		
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		row.cellDeselectAction?(indexPath: indexPath, cell: cell)
	}
}

public extension UITableView {
	public func sectionForIndex(index: Int) -> TableViewSectionType? {
		guard let sections = sections else {
			print("warning: no sections in \(self)")
			return nil
		}
		
		if index < sections.count {
			let section = sections[index]
			return section
		} else {
			print("warning: seciton index out of range")
			return nil
		}
	}
	
	public func rowForIndexPath(indexPath: NSIndexPath) -> TableViewRowType? {
		guard let sections = sections else {
			print("warning: no sections in \(self)")
			return nil
		}
		
		guard indexPath.section < sections.count else {
			print("warning: seciton index out of range")
			return nil
		}
		
		let section = sections[indexPath.section]
		guard indexPath.row < section.rows.count else {
			print("warning: row index out of range")
			return nil
		}
		
		return section.rows[indexPath.row]
	}
}
