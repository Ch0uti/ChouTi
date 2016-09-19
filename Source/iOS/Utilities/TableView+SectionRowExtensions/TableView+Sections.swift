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
			if object == nil {
				tearUp()
			} else {
				setup()
			}
			objc_setAssociatedObject(self, &zhSectionsKey.Key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	private func setup() {
		if dataSource == nil {
			dataSource = self
        } else if dataSource !== self {
            NSLog("Warning: tableView.dataSource is not nil, setting sections won't have effects. TableView: \(self)")
        }
		
		if delegate == nil {
			delegate = self
        } else if delegate !== self {
            NSLog("Warning: tableView.delegate is not nil, setting sections won't have effects. TableView: \(self)")
        }
        
        self.rowHeight = UITableViewAutomaticDimension
        
		TableViewCell.registerInTableView(self)
		TableViewCellValue1.registerInTableView(self)
		TableViewCellValue2.registerInTableView(self)
		TableViewCellSubtitle.registerInTableView(self)
	}
	
	private func tearUp() {
		dataSource = nil
		delegate = nil
		
		TableViewCell.deregisterInTableView(self)
		TableViewCellValue1.deregisterInTableView(self)
		TableViewCellValue2.deregisterInTableView(self)
		TableViewCellSubtitle.deregisterInTableView(self)
	}
}



// MARK: - TableView DataSource Methods
extension UITableView : UITableViewDataSource {
    // Row
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return sections?.count ?? 0
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionForIndex(section)?.rows.count ?? 0
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let row = rowForIndexPath(indexPath) else {
			print("Error: row not found")
			return UITableViewCell()
		}
		
		var cell: UITableViewCell! = nil
		
		if let cellInitialization = row.cellInitialization {
			cell = cellInitialization(indexPath, tableView)
		} else {
            cell = tableView.dequeueReusableCell(withClass: TableViewCellSubtitle.self)
		}
		
		tableView.tableView(tableView, cellConfigurationForCell: cell, atIndexPath: indexPath)
		
		return cell
	}
	
	private func tableView(tableView: UITableView, cellConfigurationForCell cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        rowForIndexPath(indexPath)?.cellConfiguration?(indexPath, cell, tableView)
	}
	
    // Section Index
	public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
		guard let sections = sections else {
			print("Warning: no sections in \(self)")
			return nil
		}
		
		// If there's no one section wants show index, return nil
		if sections.filter({ $0.shouldShowIndex }).count == 0 {
			return nil
		}
		
		return sections.map { $0.shouldShowIndex ? ($0.headerTitle ?? "") : "" }
	}
	
	// Header
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionForIndex(section)?.headerTitle
    }
	
	// Footer
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionForIndex(section)?.footerTitle
    }
}


// MARK: - TableView Delegate Methods
extension UITableView : UITableViewDelegate {
    // Row
	public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
	}
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		rowForIndexPath(indexPath)?.cellSelectAction?(indexPath, tableView.cellForRowAtIndexPath(indexPath), tableView)
	}
	
	public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		rowForIndexPath(indexPath)?.cellDeselectAction?(indexPath, tableView.cellForRowAtIndexPath(indexPath), tableView)
	}
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        rowForIndexPath(indexPath)?.willDisplayCell?(indexPath, cell, tableView)
    }
    
    // Header
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionForIndex(section)?.headerHeight?(section, tableView) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionForIndex(section)?.headerView?(section, tableView)
    }
    
    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        sectionForIndex(section)?.headerWillDisplay?(section, view, tableView)
    }
    
    // Footer
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionForIndex(section)?.footerHeight?(section, tableView) ?? UITableViewAutomaticDimension
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sectionForIndex(section)?.footerView?(section, tableView)
    }
    
    public func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        sectionForIndex(section)?.footerWillDisplay?(section, view, tableView)
    }
}

public extension UITableView {
	public func sectionForIndex(index: Int) -> TableViewSectionType? {
		guard let sections = sections else {
			print("Warning: no sections in \(self)")
			return nil
		}
		
		if index < sections.count {
			let section = sections[index]
			return section
		} else {
			print("Warning: seciton index out of range")
			return nil
		}
	}
	
	public func rowForIndexPath(indexPath: NSIndexPath) -> TableViewRowType? {
		guard let sections = sections else {
			print("Warning: no sections in \(self)")
			return nil
		}
		
		guard indexPath.section < sections.count else {
			print("Warning: seciton index out of range")
			return nil
		}
		
		let section = sections[indexPath.section]
		guard indexPath.row < section.rows.count else {
			print("Warning: row index out of range")
			return nil
		}
		
		return section.rows[indexPath.row]
	}
}
