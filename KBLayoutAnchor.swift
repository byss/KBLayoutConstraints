//
//  NSLayoutAnchorsProviding.swift
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

public struct KBLayoutAnchor <AnchorType> {
	private unowned (unsafe) let item: AnyObject;
	private let attribute: NSLayoutConstraint.Attribute;
	private let multiplier: CGFloat;
	private let constant: CGFloat;
	
	public static func + (lhs: KBLayoutAnchor, rhs: CGFloat) -> KBLayoutAnchor {
		return KBLayoutAnchor (item: lhs.item, attribute: lhs.attribute, multiplier: lhs.multiplier, constant: lhs.constant + rhs);
	}
	
	public static func + (lhs: KBLayoutAnchor, rhs: Double) -> KBLayoutAnchor {
		return lhs + CGFloat (rhs);
	}
	
	public static func - (lhs: KBLayoutAnchor, rhs: CGFloat) -> KBLayoutAnchor {
		return lhs + (-rhs);
	}
	
	public static func - (lhs: KBLayoutAnchor, rhs: Double) -> KBLayoutAnchor {
		return lhs - CGFloat (rhs);
	}
	
	public static func * (lhs: KBLayoutAnchor, rhs: CGFloat) -> KBLayoutAnchor {
		return KBLayoutAnchor (item: lhs.item, attribute: lhs.attribute, multiplier: lhs.multiplier * rhs, constant: lhs.constant * rhs);
	}

	public static func * (lhs: KBLayoutAnchor, rhs: Double) -> KBLayoutAnchor {
		return lhs * CGFloat (rhs);
	}
	
	public static func / (lhs: KBLayoutAnchor, rhs: CGFloat) -> KBLayoutAnchor {
		return lhs * (1.0 / rhs);
	}
	
	public static func / (lhs: KBLayoutAnchor, rhs: Double) -> KBLayoutAnchor {
		return lhs / CGFloat (rhs);
	}
	
	@discardableResult
	public static func == (lhs: KBLayoutAnchor, rhs: KBLayoutAnchor) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, relation: .equal);
	}

	@discardableResult
	public static func <= (lhs: KBLayoutAnchor, rhs: KBLayoutAnchor) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, relation: .lessThanOrEqual);
	}
	
	@discardableResult
	public static func >= (lhs: KBLayoutAnchor, rhs: KBLayoutAnchor) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, relation: .greaterThanOrEqual);
	}
	
	private static func makeConstraint (lhs: KBLayoutAnchor, rhs: KBLayoutAnchor, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
		let constant = (rhs.constant - lhs.constant) / lhs.multiplier;
		let multiplier = rhs.multiplier / lhs.multiplier;
		return NSLayoutConstraint (item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: multiplier, constant: constant, addToCurrentContext: true);
	}
	
	internal init (item: AnyObject, attribute: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
		self.item = item;
		self.attribute = attribute;
		self.multiplier = multiplier;
		self.constant = constant;
	}
}

extension KBLayoutAnchor: CustomStringConvertible {
	public var description: String {
		let anchorType: String;
		switch (AnchorType.self) {
		case is NSLayoutXAxisAnchor.Type:
			anchorType = "KBLayoutXAxisAnchor";
		case is NSLayoutYAxisAnchor.Type:
			anchorType = "KBLayoutYxisAnchor";
		case is NSLayoutDimension.Type:
			anchorType = "KBLayoutDimension";
		default:
			anchorType = "KBLayoutAnchor";
		}
		
		return "<\(anchorType) \"\(type (of: self.item)):\(ObjectIdentifier (self.item)).\(self.attribute.attributeName)\">";
	}
}

public typealias KBLayoutXAxisAnchor = KBLayoutAnchor <NSLayoutXAxisAnchor>;
public typealias KBLayoutYAxisAnchor = KBLayoutAnchor <NSLayoutYAxisAnchor>;
public typealias KBLayoutDimension = KBLayoutAnchor <NSLayoutDimension>;
internal typealias KBRawLayoutAnchor = KBLayoutAnchor <AnyObject>;

/* public */ extension KBLayoutAnchor where AnchorType == NSLayoutDimension {
	@discardableResult
	public static func == (lhs: KBLayoutAnchor, rhs: CGFloat) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, relation: .equal);
	}
	
	@discardableResult
	public static func <= (lhs: KBLayoutAnchor, rhs: CGFloat) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, relation: .lessThanOrEqual);
	}
	
	@discardableResult
	public static func >= (lhs: KBLayoutAnchor, rhs: CGFloat) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, relation: .greaterThanOrEqual);
	}
	
	private static func makeConstraint (lhs: KBLayoutAnchor, rhs: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
		let constant = (rhs - lhs.constant) / lhs.multiplier;
		return NSLayoutConstraint (item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant, addToCurrentContext: true);
	}
}

/* public */ extension Sequence where Element == KBLayoutXAxisAnchor {
	public func constraintAllAligned () -> [NSLayoutConstraint] {
		return constraintAllEqualImpl (self);
	}
}

/* public */ extension Sequence where Element == KBLayoutYAxisAnchor {
	public func constraintAllAligned () -> [NSLayoutConstraint] {
		return constraintAllEqualImpl (self);
	}
}

/* public */ extension Sequence where Element == KBLayoutDimension {
	public func constraintAllEqual () -> [NSLayoutConstraint] {
		return constraintAllEqualImpl (self);
	}
}

internal func constraintAllEqualImpl <S, AnchorType> (_ sequence: S) -> [NSLayoutConstraint] where S: Sequence, S.Element == KBLayoutAnchor <AnchorType> {
	var iterator = sequence.makeIterator ();
	guard var prevAnchor = iterator.next () else {
		return [];
	}
	
	var result = [NSLayoutConstraint] ();
	result.reserveCapacity (sequence.underestimatedCount - 1);
	while let anchor = iterator.next () {
		result.append (prevAnchor == anchor);
		prevAnchor = anchor;
	}
	return result;
}
