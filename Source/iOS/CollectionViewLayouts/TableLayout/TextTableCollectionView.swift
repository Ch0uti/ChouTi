//
//  TextTableCollectionView.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

public protocol TextTableCollectionViewDataSource : class {
	func numberOfColumnsInTableCollectionView(tableCollectionView: TextTableCollectionView) -> Int
	func tableCollectionView(tableCollectionView: TextTableCollectionView, numberOfRowsInColumn column: Int) -> Int
	func tableCollectionView(tableCollectionView: TextTableCollectionView, layout collectionViewLayout: TableCollectionViewLayout, titleForColumn column: Int) -> String
	func tableCollectionView(tableCollectionView: TextTableCollectionView, layout collectionViewLayout: TableCollectionViewLayout, contentForColumn column: Int, row: Int) -> String
}

public protocol TextTableCollectionViewDelegate : class {
	func tableCollectionView(tableCollectionView: TextTableCollectionView, configureTitleLabel titleLabel: UILabel, atColumn column: Int)
	func tableCollectionView(tableCollectionView: TextTableCollectionView, configureContentLabel contentLabel: UILabel, atColumn column: Int, row: Int)
}


// TODO: Renamed this collection view
public class TextTableCollectionView: UICollectionView {
	
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
	
    public weak var textTableDataSource: TextTableCollectionViewDataSource!
	public weak var textTableDelegate: TextTableCollectionViewDelegate?
	
	public var tableLayout: TableCollectionViewLayout!
	
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
		TextTableCollectionViewCell.registerInCollectionView(self)
		
		self.dataSource = self
		self.backgroundColor = UIColor.clearColor()
	}
	
	public override func intrinsicContentSize() -> CGSize {
		tableLayout.buildMaxWidthsHeight()
		return tableLayout.collectionViewContentSize()
	}
}

extension TextTableCollectionView : TableLayoutDataSource {
	public func numberOfColumnsInTableLayout(tableLayout: TableCollectionViewLayout) -> Int {
		return textTableDataSource.numberOfColumnsInTableCollectionView(self)
	}
	
	public func tableLayout(tableLayout: TableCollectionViewLayout, numberOfRowsInColumn column: Int) -> Int {
		// + 1 for title
		return textTableDataSource.tableCollectionView(self, numberOfRowsInColumn: column) + 1
	}
	
	public func tableLayout(tableLayout: TableCollectionViewLayout, sizeForColumn column: Int, row: Int) -> CGSize {
		let textLabel = UILabel()
		configureLabel(textLabel, forColumn: column, row: row)
		return textLabel.exactSize()
	}
}

extension TextTableCollectionView : UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfColumnsInTableLayout(tableLayout)
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableLayout(tableLayout, numberOfRowsInColumn: section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextTableCollectionViewCell.identifier(), forIndexPath: indexPath) as! TextTableCollectionViewCell
		let textLabel = cell.textLabel
		
		configureLabel(textLabel, forColumn: indexPath.section, row: indexPath.item)
		
        return cell
    }
}

extension TextTableCollectionView {
	private func configureLabel(label: UILabel, forColumn column: Int, row: Int) {
		if row == 0 {
			label.font = titleFont
			label.textColor = titleTextColor
			label.textAlignment = titleTextAlignment
			label.text = textTableDataSource.tableCollectionView(self, layout: tableLayout, titleForColumn: column)
			textTableDelegate?.tableCollectionView(self, configureTitleLabel: label, atColumn: column)
		} else {
			label.font = contentFont
			label.textColor = contentTextColor
			label.textAlignment = contentTextAlignment
			label.text = textTableDataSource.tableCollectionView(self, layout: tableLayout, contentForColumn: column, row: row - 1)
			textTableDelegate?.tableCollectionView(self, configureContentLabel: label, atColumn: column, row: row - 1)
		}
	}
}
