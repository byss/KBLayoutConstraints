//
//  UILayoutPriority+KBLayoutConstraints.swift
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
