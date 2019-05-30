//
//  KBLayoutItem.swift
//  KBLayoutConstraints
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
