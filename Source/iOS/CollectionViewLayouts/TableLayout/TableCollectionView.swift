//
//  TableCollectionView.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

public class TableCollectionView: UICollectionView {
    
    public weak var tableLayoutDataSource: TableLayoutDataSource!
	public weak var tableLayoutDelegate: TableLayoutDelegate?
	
	private var tableLayout: TableCollectionViewLayout {
		return self.collectionViewLayout as! TableCollectionViewLayout
	}
	
	// MARK: - Override
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
		precondition(layout is TableCollectionViewLayout, "layout must be a TableCollectionViewLayout class")
		commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		commonInit()
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

extension TableCollectionView: UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return tableLayoutDataSource.numberOfColumnsInCollectionView(collectionView)
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableLayoutDataSource.collectionView(collectionView, numberOfRowsInColumn: section) + 1
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TableCollectionViewCell.identifier(), forIndexPath: indexPath) as! TableCollectionViewCell
		
        if indexPath.item == 0 {
            cell.textLabel.font = tableLayout.titleFont
			cell.textLabel.textColor = tableLayout.titleTextColor
			cell.textLabel.textAlignment = tableLayout.titleTextAlignment
            cell.textLabel.text = tableLayoutDataSource.collectionView(collectionView, layout: collectionView.collectionViewLayout as! TableCollectionViewLayout, titleForColumn: indexPath.section)
        } else {
			cell.textLabel.font = tableLayout.contentFont
			cell.textLabel.textColor = tableLayout.contentTextColor
			cell.textLabel.textAlignment = tableLayout.contentTextAlignment
            cell.textLabel.text = tableLayoutDataSource.collectionView(collectionView, layout: collectionView.collectionViewLayout as! TableCollectionViewLayout, contentForColumn: indexPath.section, row: indexPath.item - 1)
        }
		
        return cell
    }
}
