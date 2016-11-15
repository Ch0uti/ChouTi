//
//  TableLayout.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

// This layout provides a grid like layout (or excel table?)

//   #  |  title |   date   |   detail
// -----+--------+----------+-----------
//   1  |  foo   |    bar   |  something
//   2  |  foo   |    bar   |   (image)
//   3  |  foo   |    bar   |  something

public protocol TableLayoutDataSource : class {
	/**
	Get number of columns
	
	- parameter tableLayout: the tableLayout
	
	- returns: number of columns
	*/
	func numberOfColumnsInTableLayout(_ tableLayout: TableCollectionViewLayout) -> Int
	
	/**
	Get number of rows in one column
	
	- parameter tableLayout: the tableLayout
	- parameter column:      column index, from 0 ... numberOfColumns
	
	- returns: number of rows in the column
	*/
	func tableLayout(_ tableLayout: TableCollectionViewLayout, numberOfRowsInColumn column: Int) -> Int
	
	/**
	Preferred size for the cell at the column and the row
	
	- parameter tableLayout: the tableLayout
	- parameter column:      column index, from 0 ... numberOfColumns
	- parameter row:         row index, begin with 0
	
	- returns: Size for the cell
	*/
	func tableLayout(_ tableLayout: TableCollectionViewLayout, sizeForColumn column: Int, row: Int) -> CGSize
}

open class TableCollectionViewLayout: UICollectionViewLayout {
    // SeparatorLine is decorationViews
	
	// MARK: - Appearance Customization	
    open var horizontalPadding: CGFloat = 5.0
    open var verticalPadding: CGFloat = 1.0
    open var separatorLineWidth: CGFloat = 1.0
    open var separatorColor = UIColor(white: 0.0, alpha: 0.5) {
        didSet {
            TableCollectionViewSeparatorView.separatorColor = separatorColor
        }
    }
	
	// MARK: - DataSource/Delegate
    open weak var dataSourceTableLayout: TableLayoutDataSource!
	
	open func numberOfColumns() -> Int {
		return dataSourceTableLayout.numberOfColumnsInTableLayout(self)
	}
	open func numberOfRowsInColumn(_ column: Int) -> Int {
		return dataSourceTableLayout.tableLayout(self, numberOfRowsInColumn: column)
	}
	
    fileprivate var maxWidthForColumn = [CGFloat]()
	fileprivate var maxHeightForRow = [CGFloat]()
	
	fileprivate var maxNumberOfRows: Int = 0
	/// Max height, not include paddings/separatorWidth
	fileprivate var maxHeight: CGFloat = 0
    
    fileprivate let separatorViewKind = "Separator"
	
	// MARK: - Init
	public override init() {
        super.init()
		commmonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		commmonInit()
    }
	
	fileprivate func commmonInit() {
		self.register(TableCollectionViewSeparatorView.self, forDecorationViewOfKind: separatorViewKind)
	}
	
	// MARK: - Override
    open override func prepare() {
        buildMaxWidthsHeight()
    }
    
    open override var collectionViewContentSize : CGSize {
        var width: CGFloat = maxWidthForColumn.reduce(0, +)
        width += CGFloat(numberOfColumns() - 1) * separatorLineWidth
        width += CGFloat(numberOfColumns()) * horizontalPadding * 2
		let maxContentHeight = maxHeight + separatorLineWidth + verticalPadding * 2 * CGFloat(maxNumberOfRows)
        return CGSize(width: width, height: maxContentHeight)
    }
        
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrisForIndexPath(indexPath)
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == separatorViewKind {
            if indexPath.item == 0 {
				let attrs = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
				// Section 0 decoration view (separator line) is horizontal line
                if indexPath.section == 0 {
                    let x: CGFloat = 0
                    let y = maxHeightForRow[0] + verticalPadding * 2
                    let width = collectionViewContentSize.width
                    attrs.frame = CGRect(x: x, y: y, width: width, height: separatorLineWidth)
                } else {
                    var x: CGFloat = 0
                    for sec in 0 ..< indexPath.section {
                        x += maxWidthForColumn[sec] + separatorLineWidth + horizontalPadding * 2
                    }
                    x -= separatorLineWidth
                    let y: CGFloat = 0.0
                    let width = separatorLineWidth
                    let height = collectionViewContentSize.height
                    attrs.frame = CGRect(x: x, y: y, width: width, height: height)
                }
				
				return attrs
            }
        }
		
		return nil
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = [UICollectionViewLayoutAttributes]()
        let cellIndexPaths = cellIndexPathsForRect(rect)
        for indexPath in cellIndexPaths {
            attrs.append(cellAttrisForIndexPath(indexPath))
        }
		
		let columns = numberOfColumns()
        for sec in 0 ..< columns {
			let rows = numberOfRowsInColumn(sec)
            for row in 0 ..< rows {
				if let attr = layoutAttributesForDecorationView(ofKind: separatorViewKind, at: IndexPath(item: row, section: sec)) {
					attrs.append(attr)
				}
            }
        }
        
        return attrs
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}

// MARK: Helper functions
extension TableCollectionViewLayout {
	func buildMaxWidthsHeight() {
        maxWidthForColumn.removeAll()
		maxHeight = 0
		
		let columns = numberOfColumns()
        for col in 0 ..< columns {
			var maxWidth: CGFloat = 0
			var height: CGFloat = 0
			let rows = numberOfRowsInColumn(col)
            for row in 0 ..< rows {
				let size = dataSourceTableLayout.tableLayout(self, sizeForColumn: col, row: row)
				let width = size.width
				height += size.height
                if width > maxWidth {
                    maxWidth = width
                }
            }
			
            maxWidthForColumn.append(maxWidth)
			
			if height > maxHeight {
				maxHeight = height
			}
        }
		
		// Calculate max number of rows
		maxNumberOfRows = 0
		for col in 0 ..< columns {
			let rows = numberOfRowsInColumn(col)
			if rows > maxNumberOfRows {
				maxNumberOfRows = rows
			}
		}
		
		// Calculate max height for row
		maxHeightForRow.removeAll()
		for row in 0 ..< maxNumberOfRows {
			var maxHeight: CGFloat = 0
			for col in 0 ..< columns {
				let rowsInColumn = numberOfRowsInColumn(col)
				if row < rowsInColumn {
					let size = dataSourceTableLayout.tableLayout(self, sizeForColumn: col, row: row)
					if size.height > maxHeight {
						maxHeight = size.height
					}
				}
			}
			maxHeightForRow.append(maxHeight)
		}
    }
	
    fileprivate func cellAttrisForIndexPath(_ indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		// Calculate Cell size with max width and max height
		let maxWidth = maxWidthForColumn[indexPath.section] + horizontalPadding * 2
		let maxHeight = maxHeightForRow[indexPath.row] + verticalPadding * 2
		
		var x: CGFloat = 0
		for sec in 0 ..< indexPath.section {
			x += maxWidthForColumn[sec] + separatorLineWidth + horizontalPadding * 2
		}
		
		var y: CGFloat = 0
		for row in 0 ..< indexPath.item {
			y += maxHeightForRow[row] + verticalPadding * 2
			if row == 0 {
				y += separatorLineWidth
			}
		}
		
		// Until now, we have frame for full size cell.
		// the frame for the cell should have size from dataSource and put it in center
		let size = dataSourceTableLayout.tableLayout(self, sizeForColumn: indexPath.section, row: indexPath.item)
        attrs.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        attrs.center = CGPoint(x: x + maxWidth / 2.0, y: y + maxHeight / 2.0)
		
        return attrs
    }

    fileprivate func cellIndexPathsForRect(_ rect: CGRect) -> [IndexPath] {
        let rectLeft: CGFloat = rect.origin.x
        let rectRight: CGFloat = rect.origin.x + rect.width
        let rectTop: CGFloat = rect.origin.y
        let rectBottom: CGFloat = rect.origin.y + rect.height
        
        var fromSectionIndex = -1
        var endSectionIndex = -1
        
        // Determin section
        var calX: CGFloat = 0.0
		let columns = numberOfColumns()
        for col in 0 ..< columns {
            let nextWidth = maxWidthForColumn[col] + horizontalPadding * 2 + separatorLineWidth
            if calX < rectLeft && rectLeft <= (calX + nextWidth) {
                fromSectionIndex = col
            }
            if calX < rectRight && rectRight <= (calX + nextWidth) {
                endSectionIndex = col
                break
            }
            calX += nextWidth
        }
        if fromSectionIndex == -1 {
            fromSectionIndex = 0
        }
        if endSectionIndex == -1 {
            endSectionIndex = columns - 1
        }
		
		// Create array of indexPaths
		var indexPaths = [IndexPath]()
		
		// Determin row
		for col in fromSectionIndex ... endSectionIndex {
			var fromRowIndex = -1
			var endRowIndex = -1
			var calY: CGFloat = 0.0
			let rowsCount = numberOfRowsInColumn(col)
			
			for row in 0 ..< rowsCount {
				var nextHeight = maxHeightForRow[row]
				if row == 0 {
					nextHeight += separatorLineWidth
				}
				if calY < rectTop && rectTop <= (calY + nextHeight) {
					fromRowIndex = row
				}
				if calY < rectBottom && rectBottom <= (calY + nextHeight) {
					endRowIndex = row
					break
				}
				calY += nextHeight
			}
			
			if fromRowIndex == -1 {
				fromRowIndex = 0
			}
			if endRowIndex == -1 {
				endRowIndex = rowsCount - 1
			}
			
			for row in fromRowIndex ... endRowIndex {
				indexPaths.append(IndexPath(item: row, section: col))
			}
		}
		
        return indexPaths
    }
}
