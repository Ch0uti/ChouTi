//
//  TableCollectionView.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

public class TableCollectionView: UICollectionView {
    
    public weak var tableLayoutDataSource: TableLayoutDataSource!
    
    private var kCellIdentifier = "Cell"
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.dataSource = self
        self.registerClass(TableCollectionViewCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
//        scrollIndicatorInsets = UIEdgeInsetsMake(5, 2, -5, -2)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! TableCollectionViewCell
        if indexPath.item == 0 {
            cell.textLabel.font = (self.collectionViewLayout as! TableCollectionViewLayout).titleFont
            cell.textLabel.text = tableLayoutDataSource.collectionView(collectionView, layout: collectionView.collectionViewLayout as! TableCollectionViewLayout, titleForColumn: indexPath.section)
        } else {
            cell.textLabel.font = (self.collectionViewLayout as! TableCollectionViewLayout).contentFont
            cell.textLabel.text = tableLayoutDataSource.collectionView(collectionView, layout: collectionView.collectionViewLayout as! TableCollectionViewLayout, contentForColumn: indexPath.section, row: indexPath.item - 1)
        }
        cell.textLabel.textColor = UIColor(white: 0.5, alpha: 1.0)
        cell.textLabel.textAlignment = .Center
        return cell
    }
}
