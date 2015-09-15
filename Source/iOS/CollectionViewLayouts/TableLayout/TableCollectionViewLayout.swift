//
//  TableLayout.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

@objc public protocol TableLayoutDataSource {
    func numberOfColumnsInCollectionView(collectionView: UICollectionView) -> Int
    func collectionView(collectionView: UICollectionView, numberOfRowsInColumn column: Int) -> Int
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: TableCollectionViewLayout, titleForColumn column: Int) -> String
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: TableCollectionViewLayout, contentForColumn column: Int, row: Int) -> String
}

public class TableCollectionViewLayout: UICollectionViewLayout {
    // NSIndexPath.item == 0, for title cells
    // NSIndexPath.item >  0, for content cells
    // However, for TableLayoutDataSource, column and row start from zero
    
    // SeparatorLine is decorationViews
    
    public var titleFont: UIFont = UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
    public var contentFont: UIFont = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
    
    public var horizontalPadding: CGFloat = 5.0
    public var verticalPadding: CGFloat = 1.0
    public var separatorLineWidth: CGFloat = 1.0
    public var separatorColor = UIColor(white: 0.0, alpha: 0.5) {
        didSet {
            TableCollectionViewSeparatorView.separatorColor = separatorColor
        }
    }
    
    private var titleLabelHeight: CGFloat { return "Zhang".zhExactSize(titleFont).height }
    private var contentLabelHeight: CGFloat { return "Honghao".zhExactSize(contentFont).height }
    
    public var dataSource: UICollectionViewDataSource {
        return self.collectionView!.dataSource!
    }
    public var dataSourceTableLayout: TableLayoutDataSource {
        return (self.collectionView! as! TableCollectionView).tableLayoutDataSource
    }
    
    public var sections: Int {
        return dataSource.numberOfSectionsInCollectionView!(collectionView!)
    }
    
    private var maxWidthsForSections = [CGFloat]()
    private var maxContentHeight: CGFloat = 0
    
    private var kSeparatorViewKind = "Separator"
    
    private var cellAttrsIndexPathDict = [NSIndexPath: UICollectionViewLayoutAttributes]()
    public override init() {
        super.init()
        self.registerClass(TableCollectionViewSeparatorView.self, forDecorationViewOfKind: kSeparatorViewKind)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func prepareLayout() {
        buildMaxWidthsHeight()
        buildCellAttrsDict()
    }
    
    public override func collectionViewContentSize() -> CGSize {
        var width: CGFloat = maxWidthsForSections.reduce(0, combine: +)
        width += CGFloat(sections - 1) * separatorLineWidth
        width += CGFloat(sections) * horizontalPadding * 2
        return CGSizeMake(width, maxContentHeight)
    }
        
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return cellAttrsIndexPathDict[indexPath]
    }
    
    public override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attrs = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, withIndexPath: indexPath)
        attrs.hidden = true
        if elementKind == kSeparatorViewKind {
            if indexPath.item == 0 {
                attrs.hidden = false
                if indexPath.section == 0 {
                    var x: CGFloat = 0
                    var y = titleLabelHeight + verticalPadding * 2
                    var width = self.collectionViewContentSize().width
                    attrs.frame = CGRectMake(x, y, width, separatorLineWidth)
                } else {
                    var x: CGFloat = 0
                    for sec in 0 ..< indexPath.section {
                        x += maxWidthsForSections[sec] + separatorLineWidth + horizontalPadding * 2
                    }
                    x -= separatorLineWidth
                    var y: CGFloat = 0.0
                    var width = separatorLineWidth
                    var height = self.collectionViewContentSize().height
                    attrs.frame = CGRectMake(x, y, width, height)
                }
            }
        }
        return attrs
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attrs = [UICollectionViewLayoutAttributes]()
        let cellIndexPaths = cellIndexPathsForRect(rect)
        for indexPath in cellIndexPaths {
            attrs.append(self.layoutAttributesForItemAtIndexPath(indexPath))
        }
        
        for sec in 0 ..< sections {
            for row in 0 ..< collectionView!.dataSource!.collectionView(collectionView!, numberOfItemsInSection: sec) {
                attrs.append(self.layoutAttributesForDecorationViewOfKind(kSeparatorViewKind, atIndexPath: NSIndexPath(forItem: row, inSection: sec)))
            }
        }
        
        return attrs
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return false
    }
}

// MARK: Helper functions
extension TableCollectionViewLayout {
    private func buildMaxWidthsHeight() {
        // Calculate MaxWidths
        maxWidthsForSections.removeAll(keepCapacity: false)
        for col in 0 ..< sections {
            let title = dataSourceTableLayout.collectionView(collectionView!, layout: self, titleForColumn: col)
            var maxWidth = title.zhExactSize(titleFont).width
            let items = dataSource.collectionView(collectionView!, numberOfItemsInSection: col)
            for row in 1 ..< items {
                // row: row - 1, to let row start from 0
                let content = dataSourceTableLayout.collectionView(collectionView!, layout: self, contentForColumn: col, row: row - 1)
                var contentWidth = content.zhExactSize(contentFont).width
                if contentWidth > maxWidth {
                    maxWidth = contentWidth
                }
            }
            maxWidthsForSections.append(maxWidth)
        }
        
        // Calculate Max Height
        var maxItemsCount = 0
        for i in 0 ..< sections {
            let itemsCount = dataSource.collectionView(collectionView!, numberOfItemsInSection: i)
            if maxItemsCount < itemsCount {
                maxItemsCount = itemsCount
            }
        }
        
        maxContentHeight = titleLabelHeight + verticalPadding * 2 + separatorLineWidth + CGFloat(maxItemsCount - 1) * (contentLabelHeight + verticalPadding * 2)
    }
    
    private func buildCellAttrsDict() {
        cellAttrsIndexPathDict.removeAll(keepCapacity: false)
        for sec in 0 ..< sections {
            let items = dataSource.collectionView(collectionView!, numberOfItemsInSection: sec)
            for item in 0 ..< items {
                let indexPath = NSIndexPath(forItem: item, inSection: sec)
                cellAttrsIndexPathDict[indexPath] = cellAttrisForIndexPath(indexPath)
            }
        }
    }
    
    private func cellAttrisForIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        var attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        var x: CGFloat = 0
        for sec in 0 ..< indexPath.section {
            x += maxWidthsForSections[sec] + separatorLineWidth + horizontalPadding * 2
        }
        var y: CGFloat = 0
        let width: CGFloat = maxWidthsForSections[indexPath.section] + horizontalPadding * 2
        var height =  dataSourceTableLayout.collectionView(collectionView!, layout: self, titleForColumn: indexPath.section).zhExactSize(titleFont).height + verticalPadding * 2
        
        if indexPath.item > 0 {
            y = dataSourceTableLayout.collectionView(collectionView!, layout: self, titleForColumn: indexPath.section).zhExactSize(titleFont).height + verticalPadding * 2 + separatorLineWidth
            for item in 1 ..< indexPath.item {
                y += dataSourceTableLayout.collectionView(collectionView!, layout: self, contentForColumn: indexPath.section, row: item).zhExactSize(contentFont).height + verticalPadding * 2.0
            }
            
            // row: indexPath.item - 1, to let row start from 0
            height = dataSourceTableLayout.collectionView(collectionView!, layout: self, contentForColumn: indexPath.section, row: indexPath.item - 1).zhExactSize(contentFont).height + verticalPadding * 2
        }
        
        attrs.frame = CGRectMake(x, y, width, height)
        
        return attrs
    }

    private func cellIndexPathsForRect(rect: CGRect) -> [NSIndexPath] {
        let rectLeft: CGFloat = rect.origin.x
        let rectRight: CGFloat = rect.origin.x + rect.width
        let rectTop: CGFloat = rect.origin.y
        let rectBottom: CGFloat = rect.origin.y + rect.height
        
        var fromSectionIndex = -1
        var endSectionIndex = -1
        var fromRowIndex = -1
        var endRowIndex = -1
        
        // Determin section
        var calX: CGFloat = 0.0
        for sec in 0 ..< sections {
            let nextWidth = maxWidthsForSections[sec] + horizontalPadding * 2 + separatorLineWidth
            if calX < rectLeft && rectLeft <= (calX + nextWidth) {
                fromSectionIndex = sec
            }
            if calX < rectRight && rectRight <= (calX + nextWidth) {
                endSectionIndex = sec
                break
            }
            calX += nextWidth
        }
        if fromSectionIndex == -1 {
            fromSectionIndex = 0
        }
        if endSectionIndex == -1 {
            endSectionIndex = sections - 1
        }
        
        // Determin row
        var calY: CGFloat = 0.0
        let rowsCount = dataSource.collectionView(collectionView!, numberOfItemsInSection: 0)
        for row in 0 ..< rowsCount {
            var nextHeight: CGFloat = 0.0
            if row == 0 {
                nextHeight = titleLabelHeight + verticalPadding * 2 + separatorLineWidth
            } else {
                nextHeight = contentLabelHeight + verticalPadding * 2
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
        
        // Create array of indexPaths
        var indexPaths = [NSIndexPath]()
        for sec in fromSectionIndex ... endSectionIndex {
            for row in fromRowIndex ... endRowIndex {
                indexPaths.append(NSIndexPath(forItem: row, inSection: sec))
            }
        }
        
        return indexPaths
    }
}

extension String {
    func zhExactSize(font: UIFont) -> CGSize {
        var newSize = self.sizeWithAttributes([NSFontAttributeName: font])
        if self.isEmpty {
            newSize = " ".sizeWithAttributes([NSFontAttributeName: font])
        }
        newSize.width = ceil(newSize.width)
        newSize.height = ceil(newSize.height)
        return newSize
    }
}
