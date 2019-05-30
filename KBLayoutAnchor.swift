//
//  NSLayoutAnchorsProviding.swift
//  KBLayoutConstraints
//
//  Created by Kirill Bystrov on 5/23/19.
//  Copyright © 2019 Kirill byss Bystrov. All rights reserved.
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
	
	public static func - (lhs: KBLayoutAnchor, rhs: CGFloat) -> KBLayoutAnchor {
		return lhs + (-rhs);
	}
	
	public static func * (lhs: KBLayoutAnchor, rhs: CGFloat) -> KBLayoutAnchor {
		return KBLayoutAnchor (item: lhs.item, attribute: lhs.attribute, multiplier: lhs.multiplier * rhs, constant: lhs.constant * rhs);
	}

	public static func / (lhs: KBLayoutAnchor, rhs: CGFloat) -> KBLayoutAnchor {
		return lhs * (1.0 / rhs);
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
