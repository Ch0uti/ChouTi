//
//  TableViewRow.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-02.
//
//

import Foundation

public struct TableViewRow : TableViewRowType {
	public var title: String?
	public var subtitle: String?
	public var cellInitialization: (NSIndexPath -> UITableViewCell)?
	public var cellConfiguration: ((NSIndexPath, UITableViewCell) -> Void)?
	public var cellSelectAction: ((NSIndexPath, UITableViewCell?) -> Void)?
	public var cellDeselectAction: ((NSIndexPath, UITableViewCell?) -> Void)?
	
	public init() {
		setupDefaultCellConfiguration()
	}
	
	public init(title: String? = nil,
	            subtitle: String? = nil,
	            cellInitialization: (NSIndexPath -> UITableViewCell)? = nil,
	            cellConfiguration: ((NSIndexPath, UITableViewCell) -> Void)? = nil,
	            cellSelectAction: ((NSIndexPath, UITableViewCell?) -> Void)? = nil,
	            cellDeselectAction: ((NSIndexPath, UITableViewCell?) -> Void)? = nil) {
		self.title = title
		self.subtitle = subtitle
		
		self.cellInitialization = cellInitialization
		
		if let cellConfiguration = cellConfiguration {
			self.cellConfiguration = cellConfiguration
		} else {
			setupDefaultCellConfiguration()
		}
		
		self.cellSelectAction = cellSelectAction
		self.cellDeselectAction = cellDeselectAction
	}
	
	private mutating func setupDefaultCellConfiguration() {
		self.cellConfiguration = { indexPath, cell in
			cell.textLabel?.text = self.title
			cell.detailTextLabel?.text = self.subtitle
			cell.detailTextLabel?.textColor = UIColor(white: 0.25, alpha: 1.0)
		}
	}
}
