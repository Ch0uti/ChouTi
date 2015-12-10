//
//  CGRect+Extensions.swift
//  Pods
//
//  Created by Honghao Zhang on 2015-12-09.
//
//

import Foundation

public extension CGRect {
	public var x: CGFloat {
		return origin.x
	}
	
	public var y: CGFloat {
		return origin.y
	}
	
	public var top: CGFloat {
		return y
	}
	
	public var bottom: CGFloat {
		return y + height
	}
	
	public var leading: CGFloat {
		return x
	}
	
	public var trailing: CGFloat {
		return x + width
	}
	
	public var left: CGFloat {
		return leading
	}
	
	public var right: CGFloat {
		return trailing
	}
}
