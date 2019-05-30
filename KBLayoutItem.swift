//
//  KBLayoutItem.swift
//  KBLayoutConstraints
//
//  Created by Kirill Bystrov on 5/23/19.
//  Copyright © 2019 Kirill byss Bystrov. All rights reserved.
//

import UIKit

public protocol KBLayoutItem: AnyObject {
	var leading: KBLayoutXAxisAnchor { get }
	var centerX: KBLayoutXAxisAnchor { get }
	var trailing: KBLayoutXAxisAnchor { get }

	var left: KBLayoutXAxisAnchor { get }
	var right: KBLayoutXAxisAnchor { get }
	
	var top: KBLayoutYAxisAnchor { get }
	var centerY: KBLayoutYAxisAnchor { get }
	var bottom: KBLayoutYAxisAnchor { get }
	
	var width: KBLayoutDimension { get }
	var height: KBLayoutDimension { get }
}

/* public */ extension KBLayoutItem {
	public var leading: KBLayoutXAxisAnchor { return self.anchor (attribute: .leading) }
	public var centerX: KBLayoutXAxisAnchor { return self.anchor (attribute: .centerX) }
	public var trailing: KBLayoutXAxisAnchor { return self.anchor (attribute: .trailing) }
	
	public var left: KBLayoutXAxisAnchor { return self.anchor (attribute: .left) }
	public var right: KBLayoutXAxisAnchor { return self.anchor (attribute: .right) }
	
	public var top: KBLayoutYAxisAnchor { return self.anchor (attribute: .top) }
	public var centerY: KBLayoutYAxisAnchor { return self.anchor (attribute: .centerY) }
	public var bottom: KBLayoutYAxisAnchor { return self.anchor (attribute: .bottom) }
	
	public var width: KBLayoutDimension { return self.anchor (attribute: .width) }
	public var height: KBLayoutDimension { return self.anchor (attribute: .height) }
	
	internal func anchor <AnchorType> (attribute: NSLayoutConstraint.Attribute) -> KBLayoutAnchor <AnchorType> {
		return KBLayoutAnchor (item: self, attribute: attribute);
	}
}

extension UILayoutGuide: KBLayoutItem {}

extension UIView: KBLayoutItem {
	public var firstBaseline: KBLayoutYAxisAnchor { return self.anchor (attribute: .firstBaseline) }
	public var lastBaseline: KBLayoutYAxisAnchor { return self.anchor (attribute: .lastBaseline) }
	
	public func makeLayoutGuide () -> UILayoutGuide {
		let result = UILayoutGuide ();
		self.addLayoutGuide (result);
		return result;
	}
}
