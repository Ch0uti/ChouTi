//
//  TextTableCollectionView.swift
//  ChouTi
//
//  Created by Honghao Zhang on 3/1/15.
//

import UIKit

public protocol TextTableCollectionViewDataSource : class {
	func numberOfColumnsInTableCollectionView(_ tableCollectionView: TextTableCollectionView) -> Int
	func tableCollectionView(_ tableCollectionView: TextTableCollectionView, numberOfRowsInColumn column: Int) -> Int
	func tableCollectionView(_ tableCollectionView: TextTableCollectionView, layout collectionViewLayout: TableCollectionViewLayout, titleForColumn column: Int) -> String
	func tableCollectionView(_ tableCollectionView: TextTableCollectionView, layout collectionViewLayout: TableCollectionViewLayout, contentForColumn column: Int, row: Int) -> String
}

public protocol TextTableCollectionViewDelegate : class {
	func tableCollectionView(_ tableCollectionView: TextTableCollectionView, configureTitleLabel titleLabel: UILabel, atColumn column: Int)
	func tableCollectionView(_ tableCollectionView: TextTableCollectionView, configureContentLabel contentLabel: UILabel, atColumn column: Int, row: Int)
}


open class TextTableCollectionView: UICollectionView {
	
	// MARK: - Appearance
	open var titleFont: UIFont = UIFont.italicSystemFont(ofSize: 17)
	open var contentFont: UIFont = UIFont.systemFont(ofSize: 17)
	
	open var titleTextColor: UIColor = UIColor(white: 0.5, alpha: 1.0)
	open var contentTextColor: UIColor = UIColor(white: 0.5, alpha: 1.0)
	
	open var titleTextAlignment: NSTextAlignment = .center
	open var contentTextAlignment: NSTextAlignment = .center

	open var horizontalPadding: CGFloat {
		set { tableLayout.horizontalPadding = newValue }
		get { return tableLayout.horizontalPadding }
	}
	open var verticalPadding: CGFloat {
		set { tableLayout.verticalPadding = newValue }
		get { return tableLayout.verticalPadding }
	}
	open var separatorLineWidth: CGFloat {
		set { tableLayout.separatorLineWidth = newValue }
		get { return tableLayout.separatorLineWidth }
	}
	open var separatorColor: UIColor {
		set { tableLayout.separatorColor = newValue }
		get { return tableLayout.separatorColor }
	}
	
    open weak var textTableDataSource: TextTableCollectionViewDataSource!
	open weak var textTableDelegate: TextTableCollectionViewDelegate?
	
    open var tableLayout: TableCollectionViewLayout {
        guard let tableLayout = collectionViewLayout as? TableCollectionViewLayout else {
            fatalError("collectionViewLayout must be a TableCollectionViewLayout instance")
        }
        return tableLayout
    }
	
	// MARK: - Override
	public convenience init() {
		let tableLayout = TableCollectionViewLayout()
		self.init(frame: CGRect.zero, collectionViewLayout: tableLayout)
	}
	
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
		guard layout is TableCollectionViewLayout else {
			fatalError("layout must be a TableCollectionViewLayout class")
		}
		tableLayout.dataSourceTableLayout = self
		commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	fileprivate func commonInit() {
		TextTableCollectionViewCell.register(inCollectionView: self)
		
		self.dataSource = self
		self.backgroundColor = UIColor.clear
	}
	
	open override var intrinsicContentSize : CGSize {
		tableLayout.buildMaxWidthsHeight()
		return tableLayout.collectionViewContentSize
	}
}

extension TextTableCollectionView : TableLayoutDataSource {
	public func numberOfColumnsInTableLayout(_ tableLayout: TableCollectionViewLayout) -> Int {
		return textTableDataSource.numberOfColumnsInTableCollectionView(self)
	}
	
	public func tableLayout(_ tableLayout: TableCollectionViewLayout, numberOfRowsInColumn column: Int) -> Int {
		// + 1 for title
		return textTableDataSource.tableCollectionView(self, numberOfRowsInColumn: column) + 1
	}
	
	public func tableLayout(_ tableLayout: TableCollectionViewLayout, sizeForColumn column: Int, row: Int) -> CGSize {
		let textLabel = UILabel()
		configureLabel(textLabel, forColumn: column, row: row)
		return textLabel.exactSize()
	}
}

extension TextTableCollectionView : UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfColumnsInTableLayout(tableLayout)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableLayout(tableLayout, numberOfRowsInColumn: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextTableCollectionViewCell.identifier(), for: indexPath) as! TextTableCollectionViewCell
		let textLabel = cell.textLabel
		
		configureLabel(textLabel, forColumn: indexPath.section, row: indexPath.item)
		
        return cell
    }
}

extension TextTableCollectionView {
	fileprivate func configureLabel(_ label: UILabel, forColumn column: Int, row: Int) {
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
