//
//  SearchTextField.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2016-02-14.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import UIKit

public protocol SearchTextFieldDelegate: class {
    func searchTextFieldDidEdit(searchTextField: SearchTextField)
    func searchTextField(searchTextField: SearchTextField, willSelectIndex index: Int)
    func searchTextField(searchTextField: SearchTextField, didSelectIndex index: Int)
}

public protocol SearchTextFieldDataSource: class {
    func numberOfResults(forQueryString queryString: String?, inSearchTextField searchTextField: SearchTextField) -> Int
    func resultString(forIndex index: Int, inSearchTextField searchTextField: SearchTextField) -> String
    func resultAttributedString(forIndex index: Int, inSearchTextField searchTextField: SearchTextField) -> NSAttributedString?
    
    func configure(forResultCell resultCell: UITableViewCell, forIndex index: Int, inSearchTextField searchTextField: SearchTextField)
}

public class SearchTextField: TextField {
	public var maxNumberOfResults: Int = 3
    
	public weak var searchTextFieldDelegate: SearchTextFieldDelegate?
	public weak var searchTextFieldDataSource: SearchTextFieldDataSource?
    
    private var originalDelegate: UITextFieldDelegate?
    public override weak var delegate: UITextFieldDelegate? {
        didSet {
            originalDelegate = delegate
            super.delegate = self
        }
    }
    
	private var _resultTextColor: UIColor?
	/// Result text color
	public var resultTextColor: UIColor? {
		get {
			return _resultTextColor ?? UIColor.blackColor()
		}
		
		set {
			_resultTextColor = newValue
		}
	}
	
	private var _resultTextFont: UIFont?
	/// Menu results text font
	public var resultTextFont: UIFont? {
		get {
			return _resultTextFont ?? font
		}
		set {
			_resultTextFont = newValue
		}
	}
	
	private var _resultTextAlignment: NSTextAlignment?
	/// Menu results text alignment
	public var resultTextAlignment: NSTextAlignment {
		get {
			return _resultTextAlignment ?? textAlignment ?? .Left
		}
		set {
			_resultTextAlignment = newValue
		}
	}
	
	private var _resultCellBackgroundColor: UIColor?
	/// Menu results cell background color
	public var resultCellBackgroundColor: UIColor? {
		get {
			return _resultCellBackgroundColor ?? UIColor.whiteColor()
		}
		set {
			_resultCellBackgroundColor = newValue
		}
	}
    
    private var _resultCellHeight: CGFloat?
    public var resultCellHeight: CGFloat {
        get {
            return _resultCellHeight ?? height
        }
        
        set {
            _resultCellHeight = newValue
        }
    }
	
	private var _resultSeparatorColor: UIColor? {
		didSet {
			resultTableView.separatorColor = _resultSeparatorColor
		}
	}
	/// Color for separator between results
	public var resultSeparatorColor: UIColor? {
		get {
			return _resultSeparatorColor ?? UIColor(white: 0.75, alpha: 1.0)
		}
		set {
			_resultSeparatorColor = newValue
		}
	}
	
	private let resultTableView = UITableView()
	
    private let searchTextFieldDidEdit = #selector(SearchTextField.zhh_searchTextFieldDidEdit(_:))
	
    private var overlayView: UIView?
	
	private var heightConstraint: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
        autocorrectionType = .No
        
		resultTableView.translatesAutoresizingMaskIntoConstraints = false
		resultTableView.backgroundColor = UIColor.clearColor()
		
		resultTableView.separatorStyle = .SingleLine
		resultTableView.separatorInset = UIEdgeInsetsZero
		
		resultTableView.dataSource = self
		resultTableView.delegate = self
		resultTableView.rowHeight = UITableViewAutomaticDimension
		resultTableView.tableFooterView = UIView()
        
		resultTableView.canCancelContentTouches = true
		resultTableView.delaysContentTouches = true
		
		resultTableView.showsVerticalScrollIndicator = false
		resultTableView.showsHorizontalScrollIndicator = false
        resultTableView.scrollEnabled = false
		
		TableViewCell.registerInTableView(resultTableView)
        
		addTarget(self, action: searchTextFieldDidEdit, forControlEvents: .EditingChanged)
        super.delegate = self
	}
	
	deinit {
		removeTarget(self, action: searchTextFieldDidEdit, forControlEvents: .EditingChanged)
	}
    
    public func reloadResults() {
        resultTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
}



// MARK: - UITextFieldDelegate
extension SearchTextField : UITextFieldDelegate {
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return originalDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        originalDelegate?.textFieldDidBeginEditing?(textField)
        zhh_searchTextFieldDidEdit(textField)
    }
    
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return originalDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        originalDelegate?.textFieldDidEndEditing?(textField)
        tearDownOverlayView()
        tearDownResultTableView()
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return originalDelegate?.textField?(textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
    }
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        return originalDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        return originalDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
	func zhh_searchTextFieldDidEdit(textField: UITextField) {
        searchTextFieldDelegate?.searchTextFieldDidEdit(self)
		if textField.text == nil || textField.text?.isEmpty == true {
            tearDownOverlayView()
			tearDownResultTableView()
		} else {
			setupOverlayView()
			setupResultTableView()
		}
	}
}



// MARK: - Helper
extension SearchTextField {
	private func setupOverlayView() {
        if overlayView != nil {
            return
        }
        
		guard let window = window else {
			NSLog("\(self).window is nil")
			return
		}
				
		overlayView = window.insertOverlayViewBelowSubview(self, animated: false, overlayViewBackgroundColor: UIColor.clearColor())
		overlayView?.userInteractionEnabled = false
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(SearchTextField.overlayViewTapped(_:)))
        overlayView?.addGestureRecognizer(tap)
	}
    
    private func tearDownOverlayView() {
        if overlayView == nil {
            return
        }
        
        guard let window = window else {
            NSLog("\(self).window is nil")
            return
        }
        
        window.removeOverlayView()
        overlayView = nil
    }
	
	private func setupResultTableView() {
		if resultTableView.superview != nil {
			return
		}
		
		guard let window = window else {
			NSLog("\(self).window is nil")
			return
		}
		
		window.insertSubview(resultTableView, aboveSubview: self)

		var constraints = [NSLayoutConstraint]()
		
        constraints += [NSLayoutConstraint(item: resultTableView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)]
        constraints += [NSLayoutConstraint(item: resultTableView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)]
		constraints += [NSLayoutConstraint(item: resultTableView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)]
		heightConstraint = NSLayoutConstraint(item: resultTableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: CGFloat(maxNumberOfResults) * (0.5 + resultCellHeight))
		constraints += [heightConstraint]
        
		NSLayoutConstraint.activateConstraints(constraints)
	}
    
    private func tearDownResultTableView() {
        resultTableView.removeFromSuperview()
    }
    
    func overlayViewTapped(tapGesture: UITapGestureRecognizer) {
        self.resignFirstResponder()
    }
}



// MARK: - UITableViewDataSource
extension SearchTextField : UITableViewDataSource {
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchTextFieldDataSource?.numberOfResults(forQueryString: text, inSearchTextField: self) ?? 0
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier()) as! TableViewCell
		
        if let attributedText = searchTextFieldDataSource?.resultAttributedString(forIndex: indexPath.row, inSearchTextField: self) {
            cell.textLabel?.attributedText = attributedText
        } else {
            cell.textLabel?.text = searchTextFieldDataSource?.resultString(forIndex: indexPath.row, inSearchTextField: self)
        }
		
		cell.cellHeight = resultCellHeight
		cell.textLabel?.textColor = resultTextColor
		cell.textLabel?.font = resultTextFont
		cell.textLabel?.textAlignment = resultTextAlignment
		cell.backgroundColor = resultCellBackgroundColor
		
		// Full width separator
		cell.enableFullWidthSeparator()
        
        searchTextFieldDataSource?.configure(forResultCell: cell, forIndex: indexPath.row, inSearchTextField: self)
		
		return cell
	}
}



// MARK: - UITableViewDelegate
extension SearchTextField : UITableViewDelegate {
	// MARK: - Rows
	public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return resultCellHeight
	}
	
	// MARK: - Selections
	public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        searchTextFieldDelegate?.searchTextField(self, willSelectIndex: indexPath.row)
        
        text = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
        
		return indexPath
	}

	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
        searchTextFieldDelegate?.searchTextField(self, didSelectIndex: indexPath.row)
        
        tearDownOverlayView()
        tearDownResultTableView()
	}
}
