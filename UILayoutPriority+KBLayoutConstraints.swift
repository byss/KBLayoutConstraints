//
//  UILayoutPriority+KBLayoutConstraints.swift
//  KBLayoutConstraints
//
//  Created by Kirill Bystrov on 5/23/19.
//  Copyright © 2019 Kirill byss Bystrov. All rights reserved.
//

import UIKit

extension UILayoutPriority: ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Float;
	
	public static let almostRequired = 999.0 as UILayoutPriority;
	public static let almostIgnored = 1.0 as UILayoutPriority;

	public init (floatLiteral value: Float) {
		self.init (rawValue: value);
	}
}

/* public */ extension NSLayoutConstraint {
	@discardableResult
	public static func % (lhs: NSLayoutConstraint, rhs: UILayoutPriority) -> NSLayoutConstraint {
		lhs.priority = rhs;
		return lhs;
	}
}

/* public */ extension Sequence where Element == NSLayoutConstraint {
	@discardableResult
	public static func % (lhs: Self, rhs: UILayoutPriority) -> [Element] {
		return lhs.map { $0 % rhs };
	}
}
