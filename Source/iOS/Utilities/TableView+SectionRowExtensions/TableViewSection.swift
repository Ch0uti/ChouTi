//
//  TableViewSection.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-15.
//
//

import Foundation

public struct TableViewSection: TableViewSectionType {
	public var headerTitle: String?
    public var headerView: ((Int, UITableView) -> UIView?)?
    public var headerHeight: ((Int, UITableView) -> CGFloat)?
    public var headerWillDisplay: ((Int, UIView, UITableView) -> Void)?
    
    public var footerTitle: String?
    public var footerView: ((Int, UITableView) -> UIView?)?
    public var footerHeight: ((Int, UITableView) -> CGFloat)?
    public var footerWillDisplay: ((Int, UIView, UITableView) -> Void)?
	
	public var rows: [TableViewRowType] = []
	
    public var shouldShowIndex: Bool = false
    
	public init() {}
	public init(headerTitle: String? = nil,
	            headerView: ((Int, UITableView) -> UIView?)? = nil,
	            headerHeight: ((Int, UITableView) -> CGFloat)? = nil,
	            headerWillDisplay: ((Int, UIView, UITableView) -> Void)? = nil,
	            footerTitle: String? = nil,
	            footerView: ((Int, UITableView) -> UIView?)? = nil,
	            footerHeight: ((Int, UITableView) -> CGFloat)? = nil,
	            footerWillDisplay: ((Int, UIView, UITableView) -> Void)? = nil,
	            rows: [TableViewRowType],
	            shouldShowIndex: Bool = false)
    {
		self.headerTitle = headerTitle
        self.headerView = headerView
        self.headerHeight = headerHeight
        self.headerWillDisplay = headerWillDisplay
        
        self.footerTitle = footerTitle
        self.footerView = footerView
        self.footerHeight = footerHeight
        self.footerWillDisplay = footerWillDisplay
        
		self.rows = rows
        self.shouldShowIndex = shouldShowIndex
	}
}
