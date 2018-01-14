//
//  TitleContentTableViewCell.swift
//  ChouTi
//
//  Created by Honghao Zhang on 2017-01-02.
//  Copyright © 2017 Honghaoz. All rights reserved.
//

import UIKit

//
// ┌─────────────────────┐
// │ Date                │
// │                     │
// │ Thursday, Jan 7     │
// │ 2017 ....           │
// └─────────────────────┘
//

public protocol TitleContentTableViewCellViewModelType {
	var title: String? { get }
	var content: String? { get }
	
	var titleColor: UIColor? { get }
	var contentColor: UIColor? { get }
	
	var titleFont: UIFont? { get }
	var contentFont: UIFont? { get }
}

public extension TitleContentTableViewCellViewModelType {
	var titleColor: UIColor? {
		return UIColor(hexString: "#535258")
	}
	var contentColor: UIColor? {
		return UIColor.black
	}
	
	var titleFont: UIFont? {
        return UIFont.gillSansLightFont(18) ?? UIFont.systemFont(ofSize: 18, weight: .light)
	}
	var contentFont: UIFont? {
		return UIFont.gillSansFont(20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
	}
}

open class TitleContentTableViewCellViewModel: TitleContentTableViewCellViewModelType {
	open var title: String?
	open var content: String?
	
	open var titleColor: UIColor? = UIColor(hexString: "#535258")
	open var contentColor: UIColor? = UIColor.black
	
    open var titleFont: UIFont? = UIFont.gillSansLightFont(18) ?? UIFont.systemFont(ofSize: 18, weight: .light)
    open var contentFont: UIFont? = UIFont.gillSansFont(20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
	
	public init(title: String?, content: String?, titleColor: UIColor? = nil, contentColor: UIColor? = nil, titleFont: UIFont? = nil, contentFont: UIFont? = nil) {
		self.title = title
		self.content = content
		self.titleColor = titleColor
		self.contentColor = contentColor
		self.titleFont = titleFont
		self.contentFont = contentFont
	}
}

open class TitleContentTableViewCell: UITableViewCell {
	open let titleLabel = UILabel().then {
		$0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.gillSansLightFont(18) ?? UIFont.systemFont(ofSize: 18, weight: .light)
		$0.textColor = UIColor(hexString: "#535258")
	}
	
	open let contentLabel = UILabel().then {
		$0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.gillSansFont(20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
		$0.textColor = UIColor.black
		$0.numberOfLines = 0
	}
	
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private final func commonInit() {
		setupViews()
		setupConstraints()
	}
	
	private final func setupViews() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(contentLabel)
	}
	
	private final func setupConstraints() {
		contentView.preservesSuperviewLayoutMargins = false
		contentView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		
		let views = [
			"titleLabel" : titleLabel,
			"contentLabel" : contentLabel
		]
		
		let metrics: [String : CGFloat] = [
			"v_spacing" : 8.0
		]
		
		var constraints = [NSLayoutConstraint]()
		
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-[contentLabel]-|", options: [.alignAllLeading, .alignAllTrailing], metrics: metrics, views: views)
		constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", options: [], metrics: metrics, views: views)
		
		NSLayoutConstraint.activate(constraints)
	}
	
	open func configure(with viewModel: TitleContentTableViewCellViewModelType) {
		titleLabel.text = viewModel.title
		contentLabel.text = viewModel.content
	}
}
