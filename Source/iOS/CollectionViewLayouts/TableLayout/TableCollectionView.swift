//
//  TableCollectionView.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

public protocol TableCollectionViewDataSource : class {
	func numberOfColumnsInTableCollectionView(tableCollectionView: TableCollectionView) -> Int
	func tableCollectionView(tableCollectionView: TableCollectionView, numberOfRowsInColumn column: Int) -> Int
	func tableCollectionView(tableCollectionView: TableCollectionView, layout collectionViewLayout: TableCollectionViewLayout, titleForColumn column: Int) -> String
	func tableCollectionView(tableCollectionView: TableCollectionView, layout collectionViewLayout: TableCollectionViewLayout, contentForColumn column: Int, row: Int) -> String
}

public protocol TableCollectionViewDelegate : class {
	func tableCollectionView(tableCollectionView: TableCollectionView, configureTitleLabel titleLabel: UILabel, atColumn column: Int)
	func tableCollectionView(tableCollectionView: TableCollectionView, configureContentLabel contentLabel: UILabel, atColumn column: Int, row: Int)
}


// TODO: Renamed this collection view
public class TableCollectionView: UICollectionView {
	
	// MARK: - Appearance
	public var titleFont: UIFont = UIFont.italicSystemFontOfSize(17)
	public var contentFont: UIFont = UIFont.systemFontOfSize(17)
	
	public var titleTextColor: UIColor = UIColor(white: 0.5, alpha: 1.0)
	public var contentTextColor: UIColor = UIColor(white: 0.5, alpha: 1.0)
	
	public var titleTextAlignment: NSTextAlignment = .Center
	public var contentTextAlignment: NSTextAlignment = .Center

	public var horizontalPadding: CGFloat {
		set { tableLayout.horizontalPadding = newValue }
		get { return tableLayout.horizontalPadding }
	}
	public var verticalPadding: CGFloat {
		set { tableLayout.verticalPadding = newValue }
		get { return tableLayout.verticalPadding }
	}
	public var separatorLineWidth: CGFloat {
		set { tableLayout.separatorLineWidth = newValue }
		get { return tableLayout.separatorLineWidth }
	}
	public var separatorColor: UIColor {
		set { tableLayout.separatorColor = newValue }
		get { return tableLayout.separatorColor }
	}
	
    public weak var tableCollectionViewDataSource: TableCollectionViewDataSource!
	public weak var tableCollectionViewDelegate: TableCollectionViewDelegate?
	
	private var tableLayout: TableCollectionViewLayout!
	
	// MARK: - Override
	public convenience init() {
		let tableLayout = TableCollectionViewLayout()
		self.init(frame: CGRectZero, collectionViewLayout: tableLayout)
	}
	
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
		guard let layout = layout as? TableCollectionViewLayout else {
			fatalError("layout must be a TableCollectionViewLayout class")
		}
		tableLayout = layout
		tableLayout.dataSourceTableLayout = self
		commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	private func commonInit() {
		TableCollectionViewCell.registerInCollectionView(self)
		
		self.dataSource = self
		self.backgroundColor = UIColor.clearColor()
	}
	
	public override func intrinsicContentSize() -> CGSize {
		tableLayout.buildMaxWidthsHeight()
		return tableLayout.collectionViewContentSize()
	}
}

extension TableCollectionView : TableLayoutDataSource {
	public func numberOfColumns() -> Int {
		return tableCollectionViewDataSource.numberOfColumnsInTableCollectionView(self)
	}
	
	public func numberOfRowsInColumn(column: Int) -> Int {
		// + 1 for title
		return tableCollectionViewDataSource.tableCollectionView(self, numberOfRowsInColumn: column) + 1
	}
	
	public func tableLayout(tableLayout: TableCollectionViewLayout, sizeForColumn column: Int, row: Int) -> CGSize {
		
		let textLabel = UILabel()
		
		if row == 0 {
			textLabel.font = titleFont
			textLabel.textColor = titleTextColor
			textLabel.textAlignment = titleTextAlignment
			textLabel.text = tableCollectionViewDataSource.tableCollectionView(self, layout: tableLayout, titleForColumn: column)
			tableCollectionViewDelegate?.tableCollectionView(self, configureTitleLabel: textLabel, atColumn: column)
		} else {
			textLabel.font = contentFont
			textLabel.textColor = contentTextColor
			textLabel.textAlignment = contentTextAlignment
			textLabel.text = tableCollectionViewDataSource.tableCollectionView(self, layout: tableLayout, contentForColumn: column, row: row - 1)
			tableCollectionViewDelegate?.tableCollectionView(self, configureContentLabel: textLabel, atColumn: column, row: row - 1)
		}
		
		print("size for col: \(column), row: \(row), text: \(textLabel.text), size: \(textLabel.exactSize())")
		print("tess: \(textLabel.preferredMaxLayoutWidth)")
		
		return textLabel.exactSize()
	}
}

extension TableCollectionView : UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfColumns()
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRowsInColumn(section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TableCollectionViewCell.identifier(), forIndexPath: indexPath) as! TableCollectionViewCell
		
        if indexPath.item == 0 {
            cell.textLabel.font = titleFont
			cell.textLabel.textColor = titleTextColor
			cell.textLabel.textAlignment = titleTextAlignment
            cell.textLabel.text = tableCollectionViewDataSource.tableCollectionView(self, layout: tableLayout, titleForColumn: indexPath.section)
			tableCollectionViewDelegate?.tableCollectionView(self, configureTitleLabel: cell.textLabel, atColumn: indexPath.section)
        } else {
			cell.textLabel.font = contentFont
			cell.textLabel.textColor = contentTextColor
			cell.textLabel.textAlignment = contentTextAlignment
            cell.textLabel.text = tableCollectionViewDataSource.tableCollectionView(self, layout: tableLayout, contentForColumn: indexPath.section, row: indexPath.item - 1)
			tableCollectionViewDelegate?.tableCollectionView(self, configureContentLabel: cell.textLabel, atColumn: indexPath.section, row: indexPath.item - 1)
        }
		
        return cell
    }
}
