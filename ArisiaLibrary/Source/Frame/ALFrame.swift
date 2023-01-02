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
	var path: ALFramePath { get }

	static var propertyTypes: Dictionary<String, CNValueType> { get }

	func setup(path pth: ALFramePath, resource res: KEResource, console cons: CNConsole) -> NSError?
}

private let FrameNameItem		= "frameName"
private let PropertyNamesItem		= "propertyNames"

public extension ALFrame
{
	typealias ListenerFunction = (JSValue) -> Void	// new-value

	var frameName:     String	 { get { return core.frameName }}
	var propertyNames: Array<String> { get { return core.propertyNames }}

	func propertyType(propertyName pname: String) -> CNValueType? {
		return core.propertyType(propertyName: pname)
	}

	func definePropertyType(propertyName pname: String, valueType vtype: CNValueType) {
		core.definePropertyType(propertyName: pname, valueType: vtype)
	}

	func definePropertyTypes(propertyTypes ptype: Dictionary<String, CNValueType>) {
		for (name, type) in ptype {
			definePropertyType(propertyName: name, valueType: type)
		}
	}

	func definePropertyType(propertyName pname: String, enumTypeName ename: String) {
		let etable = CNEnumTable.currentEnumTable()
		if let etype = etable.search(byTypeName: ename) {
			definePropertyType(propertyName: pname, valueType: .enumType(etype))
		} else {
			CNLog(logLevel: .error, message: "Enum type name \"\(ename)\" is NOT found.")
		}
	}

	func value(name nm: String) -> JSValue? {
		if let val = core.value(name: nm) {
			return val
		} else {
			return nil
		}
	}

	func setValue(name nm: String, value val: JSValue) {
		core.setValue(name: nm, value: val)
	}

	func numberValue(name nm: String) -> NSNumber? {
		if let val = value(name: nm) {
			return val.toNumber()
		} else {
			return nil
		}
	}

	func setNumberValue(name nm: String, value val: NSNumber) {
		if let valobj = JSValue(object: val, in: core.context) {
			core.setValue(name: nm, value: valobj)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate object", atFunction: #function, inFile: #file)
		}
	}

	func booleanValue(name nm: String) -> Bool? {
		if let num = numberValue(name: nm) {
			return num.boolValue
		} else {
			return nil
		}
	}

	func setBooleanValue(name nm: String, value val: Bool) {
		let num = NSNumber(booleanLiteral: val)
		setNumberValue(name: nm, value: num)
	}

	func stringValue(name nm: String) -> String? {
		if let val = core.value(name: nm) {
			if val.isString {
				return val.toString()
			}
		}
		return nil
	}

	func setStringValue(name nm: String, value val: String) {
		if let valobj = JSValue(object: val, in: core.context) {
			core.setValue(name: nm, value: valobj)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate object", atFunction: #function, inFile: #file)
		}
	}

	func objectValue(name nm: String) -> NSObject? {
		if let val = core.value(name: nm) {
			if val.isObject {
				return val.toObject() as? NSObject
			}
		}
		return nil
	}

	func setObjectValue(name nm: String, value val: NSObject) {
		if let valobj = JSValue(object: val, in: core.context) {
			core.setValue(name: nm, value: valobj)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate object", atFunction: #function, inFile: #file)
		}
	}

	func frameValue(name nm: String) -> ALFrame? {
		if let val = objectValue(name: nm) as? ALFrameCore {
			return val.owner as? ALFrame
		} else {
			return nil
		}
	}

	func setFrameValue(name nm: String, value val: ALFrame) {
		setObjectValue(name: nm, value: val.core)
	}

	func arrayValue(name nm: String) -> Array<Any>? {
		if let val = core.value(name: nm) {
			if val.isArray {
				return val.toArray()
			}
		}
		return nil
	}

	func setArrayValue(name nm: String, value val: Array<Any>) {
		if let valobj = JSValue(object: val, in: core.context) {
			core.setValue(name: nm, value: valobj)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate object", atFunction: #function, inFile: #file)
		}
	}

	func setupDefaulrProperties() {
		/* FrameName: string */
		setStringValue(name: FrameNameItem, value: self.frameName)

		/* propertyNames: string[] */
		setArrayValue(name: PropertyNamesItem, value: self.propertyNames)
	}

	func addObserver(propertyName pname: String, listnerFunction lfunc: @escaping ALFrame.ListenerFunction) {
		core.addPropertyObserver(propertyName: pname, listnerFunction: {
			(_ param: Any?) -> Void in
			if let val = param as? JSValue {
				lfunc(val)
			} else {
				CNLog(logLevel: .error, message: "Unexpected type", atFunction: #function, inFile: #file)
			}
		})
	}
}

@objc public class ALDefaultFrame: NSObject, ALFrame
{
	public static let FrameName = "Frame"

	private var mFrameCore:	ALFrameCore
	private var mPath:	ALFramePath

	public var core: ALFrameCore { get { return mFrameCore	}}
	public var path: ALFramePath { get { return mPath	}}

	public init(frameName cname: String, context ctxt: KEContext){
		mFrameCore = ALFrameCore(frameName: cname, context: ctxt)
		mPath      = ALFramePath()
		super.init()

		mFrameCore.owner = self
	}

	static public var propertyTypes: Dictionary<String, CNValueType> { get {
		let result: Dictionary<String, CNValueType> = [
			FrameNameItem:		.stringType,
			PropertyNamesItem:	.arrayType(.stringType)
		]
		return result
	}}

	public func setup(path pth: ALFramePath, resource res: KEResource, console cons: CNConsole) -> NSError? {
		mPath = pth
		self.setupDefaulrProperties()
		return nil
	}
}

