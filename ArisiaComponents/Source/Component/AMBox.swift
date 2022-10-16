/**
 * @file AMBox.swift
 * @brief	Define AMBox class
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

public class AMBox: KCStackView, ALFrame
{
	public static let ClassName 	= "Box"

	private static let AxisItem		= "axis"		// Type: CNAxis
	private static let AlignmentItem	= "alignment"		// Type: CNAlignment
	private static let DistributionItem	= "distribution"	// Type: CNDistribution

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore
	private var mPath:		ALFramePath

	public var core: ALFrameCore { get { return mFrameCore	}}
	public var path: ALFramePath { get { return mPath 	}}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMBox.ClassName, context: ctxt)
		mPath		= ALFramePath()
		let frame	= CGRect(x: 0.0, y: 0.0, width: 188, height: 21)
		super.init(frame: frame)
		mFrameCore.owner = self
	}

	public required init?(coder: NSCoder) {
		fatalError("Not supported")
	}

	public func setup(path pth: ALFramePath, resource res: KEResource, console cons: CNConsole) -> NSError? {
		/* Set path of this frame */
		mPath = pth

		/* Link with child frames */
		for pname in self.propertyNames {
			if let core = self.objectValue(name: pname) as? ALFrameCore {
				if let view = core.owner as? KCView {
					self.addArrangedSubView(subView: view)
				}
			}
		}

		/* Axis */
		definePropertyType(propertyName: AMBox.AxisItem, enumTypeName: "Axis")
		if let num = numberValue(name: AMBox.AxisItem) {
			if let newaxis = CNAxis(rawValue: num.intValue) {
				CNExecuteInMainThread(doSync: false, execute: {
					self.axis = newaxis
				})
			} else {
				CNLog(logLevel: .error, message: "Unknown initial value for \(AMBox.AxisItem)", atFunction: #function, inFile: #file)
			}
		} else {
			let _ = setNumberValue(name: AMBox.AxisItem, value: NSNumber(value: self.axis.rawValue))
		}
		addObserver(propertyName: AMBox.AxisItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				if let newaxis = CNAxis(rawValue: num.intValue) {
					CNExecuteInMainThread(doSync: false, execute: {
						self.axis = newaxis
					})
				} else {
					CNLog(logLevel: .error, message: "Invalid value for axis: \(num.intValue)", atFunction: #function, inFile: #file)
				}
			}
		})

		/* Alignment */
		definePropertyType(propertyName: AMBox.AlignmentItem, enumTypeName: "Alignment")
		if let num = numberValue(name: AMBox.AlignmentItem) {
			if let newalignment = CNAlignment(rawValue: num.intValue) {
				CNExecuteInMainThread(doSync: false, execute: {
					self.alignment = newalignment
				})
			} else {
				CNLog(logLevel: .error, message: "Unknown initial value for \(AMBox.AlignmentItem)", atFunction: #function, inFile: #file)
			}
		} else {
			let _ = setNumberValue(name: AMBox.AlignmentItem, value: NSNumber(value: self.alignment.rawValue))
		}
		addObserver(propertyName: AMBox.AlignmentItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				if let newalignment = CNAlignment(rawValue: num.intValue) {
					CNExecuteInMainThread(doSync: false, execute: {
						self.alignment = newalignment
					})
				} else {
					CNLog(logLevel: .error, message: "Invalid value for alignment: \(num.intValue)", atFunction: #function, inFile: #file)
				}
			}
		})

		/* Distribution */
		definePropertyType(propertyName: AMBox.DistributionItem, enumTypeName: "Distribution")
		if let num = numberValue(name: AMBox.DistributionItem) {
			if let newdistribution = CNDistribution(rawValue: num.intValue) {
				CNExecuteInMainThread(doSync: false, execute: {
					self.distribution = newdistribution
				})
			} else {
				CNLog(logLevel: .error, message: "Unknown initial value for \(AMBox.DistributionItem)", atFunction: #function, inFile: #file)
			}
		} else {
			let _ = setNumberValue(name: AMBox.DistributionItem, value: NSNumber(value: self.distribution.rawValue))
		}
		addObserver(propertyName: AMBox.DistributionItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				if let newdistribution = CNDistribution(rawValue: num.intValue) {
					CNExecuteInMainThread(doSync: false, execute: {
						self.distribution = newdistribution
					})
				} else {
					CNLog(logLevel: .error, message: "Invalid value for distribution: \(num.intValue)", atFunction: #function, inFile: #file)
				}
			}
		})

		/* default properties */
		self.setupDefaultProperties()
		
		return nil
	}
}


