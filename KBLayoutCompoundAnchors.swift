//
//  KBLayoutCompoundAnchors.swift
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

public struct KBLayoutPointAnchor {
	private let xAxisAnchor: KBLayoutXAxisAnchor;
	private let yAxisAnchor: KBLayoutYAxisAnchor;
	private let offset: CGVector;
	
	public static func + (lhs: KBLayoutPointAnchor, rhs: CGVector) -> KBLayoutPointAnchor {
		return KBLayoutPointAnchor (xAxisAnchor: lhs.xAxisAnchor, yAxisAnchor: lhs.yAxisAnchor, offset: CGVector (dx: lhs.offset.dx + rhs.dx, dy: lhs.offset.dy + rhs.dy));
	}

	public static func + (lhs: KBLayoutPointAnchor, rhs: (dx: CGFloat, dy: CGFloat)) -> KBLayoutPointAnchor {
		return lhs + CGVector (dx: rhs.dx, dy: rhs.dy);
	}
	
	public static func - (lhs: KBLayoutPointAnchor, rhs: CGVector) -> KBLayoutPointAnchor {
		return lhs + CGVector (dx: -rhs.dx, dy: -rhs.dy);
	}
	
	public static func - (lhs: KBLayoutPointAnchor, rhs: (dx: CGFloat, dy: CGFloat)) -> KBLayoutPointAnchor {
		return lhs - CGVector (dx: rhs.dx, dy: rhs.dy);
	}
	
	@discardableResult
	public static func == (lhs: KBLayoutPointAnchor, rhs: KBLayoutPointAnchor) -> [NSLayoutConstraint] {
		return [lhs.xAxisAnchor == rhs.xAxisAnchor + rhs.offset.dx - lhs.offset.dx, lhs.yAxisAnchor == rhs.yAxisAnchor + rhs.offset.dy - lhs.offset.dy];
	}
	
	fileprivate init (xAxisAnchor: KBLayoutXAxisAnchor, yAxisAnchor: KBLayoutYAxisAnchor, offset: CGVector = .zero) {
		self.xAxisAnchor = xAxisAnchor;
		self.yAxisAnchor = yAxisAnchor;
		self.offset = offset;
	}
}

/* public */ extension KBLayoutItem {
	public var topLeading: KBLayoutPointAnchor {
		return self.point (x: \.leading, y: \.top);
	}

	public var topTrailing: KBLayoutPointAnchor {
		return self.point (x: \.trailing, y: \.top);
	}
	
	public var bottomLeading: KBLayoutPointAnchor {
		return self.point (x: \.leading, y: \.bottom);
	}
	
	public var bottomTrailing: KBLayoutPointAnchor {
		return self.point (x: \.trailing, y: \.bottom);
	}
	
	public var center: KBLayoutPointAnchor {
		return self.point (x: \.centerX, y: \.centerY);
	}
	
	public func point (x xAxisAnchor: KBLayoutXAxisAnchor, y yAxisAnchor: KBLayoutYAxisAnchor) -> KBLayoutPointAnchor {
		return KBLayoutPointAnchor (xAxisAnchor: xAxisAnchor, yAxisAnchor: yAxisAnchor);
	}

	public func point (x xAnchorKeyPath: KeyPath <Self, KBLayoutXAxisAnchor>, y yAnchorKeyPath: KeyPath <Self, KBLayoutYAxisAnchor>) -> KBLayoutPointAnchor {
		return self.point (x: self [keyPath: xAnchorKeyPath], y: self [keyPath: yAnchorKeyPath]);
	}
}

public struct KBLayoutAspectRatioAnchor {
	private let widthAnchor: KBLayoutDimension;
	private let heightAnchor: KBLayoutDimension;
	
	@discardableResult
	public static func == (lhs: KBLayoutAspectRatioAnchor, rhs: CGFloat) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, using: ==);
	}
	
	@discardableResult
	public static func <= (lhs: KBLayoutAspectRatioAnchor, rhs: CGFloat) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, using: <=);
	}
	
	@discardableResult
	public static func >= (lhs: KBLayoutAspectRatioAnchor, rhs: CGFloat) -> NSLayoutConstraint {
		return self.makeConstraint (lhs: lhs, rhs: rhs, using: >=);
	}
	
	private static func makeConstraint (lhs: KBLayoutAspectRatioAnchor, rhs: CGFloat, using operation: (KBLayoutDimension, KBLayoutDimension) -> NSLayoutConstraint) -> NSLayoutConstraint {
		return operation (lhs.widthAnchor, lhs.heightAnchor * rhs);
	}
	
	fileprivate init (widthAnchor: KBLayoutDimension, heightAnchor: KBLayoutDimension) {
		(self.widthAnchor, self.heightAnchor) = (widthAnchor, heightAnchor);
	}
}

/* public */ extension KBLayoutItem {
	public var aspectRatio: KBLayoutAspectRatioAnchor {
		return KBLayoutAspectRatioAnchor (widthAnchor: self.width, heightAnchor: self.height);
	}
}

public struct KBLayoutSizeAnchor {
	private let widthAnchor: KBLayoutDimension;
	private let heightAnchor: KBLayoutDimension;
	
	public static func * (lhs: KBLayoutSizeAnchor, rhs: CGSize) -> KBLayoutSizeAnchor {
		return KBLayoutSizeAnchor (widthAnchor: lhs.widthAnchor * rhs.width, heightAnchor: lhs.heightAnchor * rhs.height);
	}

	public static func * (lhs: KBLayoutSizeAnchor, rhs: (width: CGFloat, height: CGFloat)) -> KBLayoutSizeAnchor {
		return lhs * CGSize (width: rhs.width, height: rhs.height);
	}
	
	public static func * (lhs: KBLayoutSizeAnchor, rhs: CGFloat) -> KBLayoutSizeAnchor {
		return lhs * CGSize (width: rhs, height: rhs);
	}

	public static func / (lhs: KBLayoutSizeAnchor, rhs: CGFloat) -> KBLayoutSizeAnchor {
		return lhs * (1.0 / rhs);
	}
	
	public static func + (lhs: KBLayoutSizeAnchor, rhs: CGSize) -> KBLayoutSizeAnchor {
		return KBLayoutSizeAnchor (widthAnchor: lhs.widthAnchor + rhs.width, heightAnchor: lhs.heightAnchor + rhs.height);
	}
	
	public static func + (lhs: KBLayoutSizeAnchor, rhs: (width: CGFloat, height: CGFloat)) -> KBLayoutSizeAnchor {
		return lhs + CGSize (width: rhs.width, height: rhs.height);
	}

	public static func - (lhs: KBLayoutSizeAnchor, rhs: CGSize) -> KBLayoutSizeAnchor {
		return lhs + CGSize (width: -rhs.width, height: -rhs.height);
	}
	
	public static func - (lhs: KBLayoutSizeAnchor, rhs: (width: CGFloat, height: CGFloat)) -> KBLayoutSizeAnchor {
		return lhs + (width: -rhs.width, height: -rhs.height);
	}
	
	@discardableResult
	public static func == (lhs: KBLayoutSizeAnchor, rhs: KBLayoutSizeAnchor) -> [NSLayoutConstraint] {
		return self.makeConstraints (lhs: lhs, rhs: rhs, operation: ==);
	}
	
	@discardableResult
	public static func <= (lhs: KBLayoutSizeAnchor, rhs: KBLayoutSizeAnchor) -> [NSLayoutConstraint] {
		return self.makeConstraints (lhs: lhs, rhs: rhs, operation: <=);
	}
	
	@discardableResult
	public static func >= (lhs: KBLayoutSizeAnchor, rhs: KBLayoutSizeAnchor) -> [NSLayoutConstraint] {
		return self.makeConstraints (lhs: lhs, rhs: rhs, operation: >=);
	}
	
	private static func makeConstraints (lhs: KBLayoutSizeAnchor, rhs: KBLayoutSizeAnchor, operation: (KBLayoutDimension, KBLayoutDimension) -> NSLayoutConstraint) -> [NSLayoutConstraint] {
		return [operation (lhs.widthAnchor, rhs.widthAnchor), operation (lhs.heightAnchor, rhs.heightAnchor)];
	}

	@discardableResult
	public static func == (lhs: KBLayoutSizeAnchor, rhs: CGSize) -> [NSLayoutConstraint] {
		return self.makeConstraints (lhs: lhs, rhs: rhs, operation: ==);
	}

	@discardableResult
	public static func == (lhs: KBLayoutSizeAnchor, rhs: (width: CGFloat, height: CGFloat)) -> [NSLayoutConstraint] {
		return lhs == CGSize (width: rhs.width, height: rhs.height);
	}
	
	@discardableResult
	public static func <= (lhs: KBLayoutSizeAnchor, rhs: CGSize) -> [NSLayoutConstraint] {
		return self.makeConstraints (lhs: lhs, rhs: rhs, operation: <=);
	}
	
	@discardableResult
	public static func <= (lhs: KBLayoutSizeAnchor, rhs: (width: CGFloat, height: CGFloat)) -> [NSLayoutConstraint] {
		return lhs <= CGSize (width: rhs.width, height: rhs.height);
	}
	
	@discardableResult
	public static func >= (lhs: KBLayoutSizeAnchor, rhs: CGSize) -> [NSLayoutConstraint] {
		return self.makeConstraints (lhs: lhs, rhs: rhs, operation: >=);
	}
	
	@discardableResult
	public static func >= (lhs: KBLayoutSizeAnchor, rhs: (width: CGFloat, height: CGFloat)) -> [NSLayoutConstraint] {
		return lhs >= CGSize (width: rhs.width, height: rhs.height);
	}
	
	private static func makeConstraints (lhs: KBLayoutSizeAnchor, rhs: CGSize, operation: (KBLayoutDimension, CGFloat) -> NSLayoutConstraint) -> [NSLayoutConstraint] {
		return [operation (lhs.widthAnchor, rhs.width), operation (lhs.heightAnchor, rhs.height)];
	}

	fileprivate init (widthAnchor: KBLayoutDimension, heightAnchor: KBLayoutDimension) {
		(self.widthAnchor, self.heightAnchor) = (widthAnchor, heightAnchor);
	}
}

/* public */ extension KBLayoutItem {
	public var size: KBLayoutSizeAnchor {
		return KBLayoutSizeAnchor (widthAnchor: self.width, heightAnchor: self.height);
	}
}

/* public */ extension KBLayoutItem {
	@discardableResult
	public func alignBounds (to item: KBLayoutItem, insets: CGFloat = 0.0, useCenterAnchor: Bool = false) -> [NSLayoutConstraint] {
		return self.alignBounds (to: item, insetX: insets, y: insets, useCenterAnchor: useCenterAnchor);
	}
	
	@discardableResult
	public func alignBounds (to item: KBLayoutItem, insetX dx: CGFloat, y dy: CGFloat, useCenterAnchor: Bool = false) -> [NSLayoutConstraint] {
		return self.alignBounds (to: item, insets: UIEdgeInsets (top: dy, left: dx, bottom: dy, right: dx), useCenterAnchor: useCenterAnchor);
	}
	
	@discardableResult
	public func alignBounds (to item: KBLayoutItem, insets: UIEdgeInsets, useCenterAnchor: Bool = false) -> [NSLayoutConstraint] {
		if (useCenterAnchor) {
			return [
				self.centerX == item.centerX + (insets.left - insets.right) / 2,
				self.centerY == item.centerY + (insets.top - insets.bottom) / 2,
				item.width == self.width + (insets.left + insets.right),
				item.height == self.height + (insets.top + insets.bottom),
			];
		} else {
			return [
				self.left == item.left + insets.left,
				item.right == self.right + insets.right,
				self.top == item.top + insets.top,
				item.bottom == self.bottom + insets.bottom,
			];
		}
	}
}

/* public */ extension UIView {
	public struct BoundsAlignmentOptions: OptionSet {
		public typealias RawValue = UInt;
		
		public static let useCenterAnchor = BoundsAlignmentOptions (rawValue: 1 << 0);
		public static let alignToSafeArea = BoundsAlignmentOptions (rawValue: 1 << 1);
		
		public let rawValue: UInt;
		
		public init (rawValue: UInt) {
			self.rawValue = rawValue;
		}
	}
	
	@discardableResult
	public func alignBoundsToSuperview (insets: CGFloat = 0.0, options: BoundsAlignmentOptions = []) -> [NSLayoutConstraint] {
		return self.alignBoundsToSuperview (insetX: insets, y: insets, options: options);
	}
	
	@discardableResult
	public func alignBoundsToSuperview (insetX dx: CGFloat, y dy: CGFloat, options: BoundsAlignmentOptions = []) -> [NSLayoutConstraint] {
		return self.alignBoundsToSuperview (insets: UIEdgeInsets (top: dy, left: dx, bottom: dy, right: dx), options: options);
	}
	
	@discardableResult
	public func alignBoundsToSuperview (insets: UIEdgeInsets, options: BoundsAlignmentOptions = []) -> [NSLayoutConstraint] {
		guard let superview = self.superview else {
			fatalError ("\(self): cannot align bounds to superview because it is not set");
		}
		return self.alignBounds (
			to: options.contains (.alignToSafeArea) ? superview.safeAreaLayoutGuide : superview,
			insets: insets,
			useCenterAnchor: options.contains (.useCenterAnchor)
		);
	}
}
