//
//  NSLayoutConstraint+make.swift
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

/* public */ extension NSLayoutConstraint {
	#if DEBUG
	@discardableResult
	public static func make (andActivate activate: Bool = true, options: FormatOptions = [], file: StaticString = #file, line: Int = #line, using block: () -> ()) -> [NSLayoutConstraint] {
		return self.perform (block) {
			Context.push (options: options, activateWhenDone: activate, debugDescription: "\(("\(file)" as NSString).lastPathComponent):\(line)");
		};
	}
	#else
	public static func make (andActivate activate: Bool = true, options: FormatOptions = [], using block: () -> ()) -> [NSLayoutConstraint] {
		return self.perform (block) {
			Context.push (options: options, activateWhenDone: activate);
		};
	}
	#endif
	
	private static func perform (_ block: () -> (), creatingContextUsing contextBlock: () -> ()) -> [NSLayoutConstraint] {
		contextBlock ();
		block ();
		return Context.pop ();
	}
	
	internal convenience init (item view1: Any, attribute attr1: Attribute, relatedBy relation: Relation, toItem view2: Any?, attribute attr2: Attribute, multiplier: CGFloat, constant: CGFloat, addToCurrentContext: Bool) {
		self.init (item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: constant);
		if (addToCurrentContext) {
			Context.current?.append (self);
		}
	}
	
	private convenience init (aligning item1: AnyObject, _ item2: AnyObject, by attribute: Attribute) {
		self.init (item: item1, attribute: attribute, relatedBy: .equal, toItem: item2, attribute: attribute, multiplier: 1.0, constant: 0.0);
	}
}

/* public */ extension NSLayoutConstraint.FormatOptions {
	public static let settingEqualWidths = NSLayoutConstraint.FormatOptions (rawValue: 1 << NSLayoutConstraint.Attribute.width.rawValue);
	public static let settingEqualheights = NSLayoutConstraint.FormatOptions (rawValue: 1 << NSLayoutConstraint.Attribute.height.rawValue);
}

/* internal */ extension NSLayoutConstraint.Attribute {
	internal var attributeName: String {
		switch (self) {
		case .left:
			return "left";
		case .right:
			return "ight";
		case .top:
			return "top";
		case .bottom:
			return "bottom";
		case .leading:
			return "leading";
		case .trailing:
			return "trailing";
		case .width:
			return "width";
		case .height:
			return "height";
		case .centerX:
			return "centerX";
		case .centerY:
			return "centerY";
		case .lastBaseline:
			return "lastBaseline";
		case .firstBaseline:
			return "firstBaseline";
		default:
			return "???";
		}
	}
}

/* private */ extension NSLayoutConstraint {
	fileprivate struct Context {
		private let options: FormatOptions;
		private let activateWhenDone: Bool;
		#if DEBUG
		private let debugDescription: String;
		#endif
		
		private var constraints = [NSLayoutConstraint] ();
		private var constraintItems = Set <UnownedWrapper> ();
	}
}

/* private */ extension NSLayoutConstraint.Context {
	private struct UnownedWrapper: Hashable {
		fileprivate var value: KBLayoutItem {
			return unsafeBitCast (self.rawValue, to: KBLayoutItem.self);
		}
		
		private let rawValue: UInt;
		
		fileprivate init (_ value: KBLayoutItem) {
			self.rawValue = unsafeBitCast (value, to: UInt.self);
		}
	}
	
	fileprivate typealias Context = NSLayoutConstraint.Context;
	fileprivate typealias FormatOptions = NSLayoutConstraint.FormatOptions;

	fileprivate static var current: Context? {
		get { return self.contextsStack.last }
		set {
			switch (self.contextsStack.isEmpty, newValue) {
			case (true, nil):
				break;
			case (false, let newValue?):
				self.contextsStack [self.contextsStack.endIndex - 1] = newValue;
			default:
				fatalError ("Cannot update contexts stack head \(self.contextsStack.last.map { "\($0)" } ?? "nil") with \(newValue.map { "\($0)" } ?? "nil")");
			}
		}
	}
	
	private static var contextsStack = [Context] ();
	
	#if DEBUG
	fileprivate static func push (options: FormatOptions, activateWhenDone: Bool, debugDescription: String) {
		self.push (.init (options: options, activateWhenDone: activateWhenDone, debugDescription: debugDescription));
	}
	#else
	fileprivate static func push (options: FormatOptions, activateWhenDone: Bool) {
		self.push (.init (options: options, activateWhenDone: activateWhenDone));
	}
	#endif
	
	fileprivate static func pop () -> [NSLayoutConstraint] {
		guard var head = self.contextsStack.popLast () else {
			return [];
		}
		head.finalize ();
		return head.constraints;
	}
	
	private static func push (_ context: Context) {
		self.contextsStack.append (context);
	}
	
	#if DEBUG
	private init (options: FormatOptions, activateWhenDone: Bool, debugDescription: String) {
		self.options = options;
		self.activateWhenDone = activateWhenDone;
		self.debugDescription = debugDescription;
	}
	#else
	private init (options: FormatOptions, activateWhenDone: Bool) {
		self.options = options;
		self.activateWhenDone = activateWhenDone;
	}
	#endif
	
	fileprivate mutating func append (_ constraint: NSLayoutConstraint) {
		self.constraints.append (constraint);
		#if DEBUG
		constraint.identifier = "\(self.debugDescription)#\(self.constraints.count)";
		#endif
		for case let item? in [constraint.firstItem as? KBLayoutItem, constraint.secondItem as? KBLayoutItem] {
			self.constraintItems.insert (UnownedWrapper (item));
		}
	}
	
	private mutating func finalize () {
		self.makeAlignmentConstraintsIfNeeded ();
		
		if (self.activateWhenDone) {
			NSLayoutConstraint.activate (self.constraints);
		}
	}
	
	private mutating func makeAlignmentConstraintsIfNeeded () {
		var alignmentOptions = self.options.intersection (.alignmentMask);
		guard (!alignmentOptions.isEmpty) else {
			return;
		}
		
		let constraintItems = self.constraintItems;
		guard constraintItems.count > 1 else {
			return;
		}
		
		self.constraints.reserveCapacity (self.constraints.count + alignmentOptions.rawValue.nonzeroBitCount * (constraintItems.count - 1));
		repeat {
			let rawAttributeValue = alignmentOptions.rawValue.trailingZeroBitCount;
			if let attribute = NSLayoutConstraint.Attribute (rawValue: rawAttributeValue) {
				self.constraints.append (contentsOf: constraintAllEqualImpl (self.constraintItems.map { $0.value.anchor (attribute: attribute) as KBRawLayoutAnchor }));
			}
			alignmentOptions.subtract (FormatOptions (rawValue: 1 << rawAttributeValue));
		} while (!alignmentOptions.isEmpty);
	}
}
