/**
 * @file	ALFrame.swift
 * @brief	Define ALFrame class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import JavaScriptCore

public protocol ALFrame
{
	var core: ALFrameCore { get }
}

public extension ALFrame
{
	var frameName: String { get {
		if let str = core.frameName.toString() {
			return str
		} else {
			CNLog(logLevel: .error, message: "No frame name", atFunction: #function, inFile: #file)
			return ""
		}
	}}

	var propertyNames: Array<String> { get {
		if let arr = core.propertyNames.toArray() as? Array<String> {
			return arr
		} else {
			CNLog(logLevel: .error, message: "No property names", atFunction: #function, inFile: #file)
			return []
		}
	}}

	func value(name nm: String) -> CNValue {
		if let val = core.value(name: nm) {
			return val.toNativeValue()
		} else {
			return CNValue.null
		}
	}

	func setValue(name nm: String, value val: CNValue) -> Bool {
		let valobj = val.toJSValue(context: core.context)
		core.setValue(name: nm, value: valobj)
		return true
	}
}

@objc public class ALDefaultFrame: NSObject, ALFrame
{
	private var mFrameCore:		ALFrameCore

	public var core: ALFrameCore { get {
		return mFrameCore
	}}

	public init(frameName cname: String, context ctxt: KEContext){
		mFrameCore = ALFrameCore(frameName: cname, context: ctxt)
	}
}
