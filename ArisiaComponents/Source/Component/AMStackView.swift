/**
 * @file AMStackView.swift
 * @brief	Define AMStackView class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiControls
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

public class AMStackView: KCStackView, ALFrame
{
	public static let ClassName 	= "StackView"

	private static let AxisItem		= "axis"		// Type: CNAxis
	private static let AlignmentItem		= "alignment"		// Type: CNAlignment
	private static let DistributionItem	= "distribution"	// Type: CNDistribution

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore

	public var core: ALFrameCore { get { return mFrameCore }}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMStackView.ClassName, context: ctxt)
		let frame	= CGRect(x: 0.0, y: 0.0, width: 188, height: 21)
		super.init(frame: frame)
		mFrameCore.owner = self
	}

	public required init?(coder: NSCoder) {
		fatalError("Not supported")
	}

	public func setup() {
		/* Link with child frames */
		for pname in self.propertyNames {
			if let core = self.objectValue(name: pname) as? ALFrameCore {
				if let view = core.owner as? KCView {
					self.addArrangedSubView(subView: view)
				}
			}
		}

		/* Axis */
		definePropertyType(propertyName: AMStackView.AxisItem, enumTypeName: "Axis")
		if let num = numberValue(name: AMStackView.AxisItem) {
			if let newaxis = CNAxis(rawValue: num.intValue) {
				self.axis = newaxis
			} else {
				CNLog(logLevel: .error, message: "Unknown initial value for \(AMStackView.AxisItem)", atFunction: #function, inFile: #file)
			}
		} else {
			let _ = setNumberValue(name: AMStackView.AxisItem, value: NSNumber(value: self.axis.rawValue))
		}
		addObserver(propertyName: AMStackView.AxisItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				if let newaxis = CNAxis(rawValue: num.intValue) {
					self.axis = newaxis
				} else {
					CNLog(logLevel: .error, message: "Invalid value for axis: \(num.intValue)", atFunction: #function, inFile: #file)
				}
			}
		})

		/* Alignment */
		definePropertyType(propertyName: AMStackView.AlignmentItem, enumTypeName: "Alignment")
		if let num = numberValue(name: AMStackView.AlignmentItem) {
			if let newalignment = CNAlignment(rawValue: num.intValue) {
				self.alignment = newalignment
			} else {
				CNLog(logLevel: .error, message: "Unknown initial value for \(AMStackView.AlignmentItem)", atFunction: #function, inFile: #file)
			}
		} else {
			let _ = setNumberValue(name: AMStackView.AlignmentItem, value: NSNumber(value: self.alignment.rawValue))
		}
		addObserver(propertyName: AMStackView.AlignmentItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				if let newalignment = CNAlignment(rawValue: num.intValue) {
					self.alignment = newalignment
				} else {
					CNLog(logLevel: .error, message: "Invalid value for alignment: \(num.intValue)", atFunction: #function, inFile: #file)
				}
			}
		})

		/* Distribution */
		definePropertyType(propertyName: AMStackView.DistributionItem, enumTypeName: "Distribution")
		if let num = numberValue(name: AMStackView.DistributionItem) {
			if let newdistribution = CNDistribution(rawValue: num.intValue) {
				self.distribution = newdistribution
			} else {
				CNLog(logLevel: .error, message: "Unknown initial value for \(AMStackView.DistributionItem)", atFunction: #function, inFile: #file)
			}
		} else {
			let _ = setNumberValue(name: AMStackView.DistributionItem, value: NSNumber(value: self.distribution.rawValue))
		}
		addObserver(propertyName: AMStackView.DistributionItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				if let newdistribution = CNDistribution(rawValue: num.intValue) {
					self.distribution = newdistribution
				} else {
					CNLog(logLevel: .error, message: "Invalid value for distribution: \(num.intValue)", atFunction: #function, inFile: #file)
				}
			}
		})
	}
}


