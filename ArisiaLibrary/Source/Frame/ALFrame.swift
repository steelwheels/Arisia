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

	func setup(resource res: KEResource) -> NSError?
}

private let FrameNameItem	= "frameName"
private let PropertyNamesItem	= "propertyNames"
private let ValueItem		= "value"
private let SetValueItem	= "setValue"

public extension ALFrame
{
	typealias ListenerFunction = (JSValue) -> Void	// new-value

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

	func propertyType(propertyName pname: String) -> CNValueType? {
		return core.propertyType(propertyName: pname)
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
		if let val = core.value(name: nm) {
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

	func definePropertyType(propertyName pname: String, valueType vtype: CNValueType) {
		core.definePropertyType(propertyName: pname, valueType: vtype)
	}

	func definePropertyType(propertyName pname: String, enumTypeName ename: String) {
		let etable = CNEnumTable.currentEnumTable()
		if let etype = etable.search(byTypeName: ename) {
			definePropertyType(propertyName: pname, valueType: .enumType(etype))
		} else {
			CNLog(logLevel: .error, message: "Enum type name \"\(ename)\" is NOT found.")
		}
	}

	func addObserver(propertyName pname: String, listnerFunction lfunc: @escaping ALFrame.ListenerFunction) {
		core.addObserver(propertyName: pname, listnerFunction: {
			(_ param: Any?) -> Void in
			if let val = param as? JSValue {
				lfunc(val)
			} else {
				CNLog(logLevel: .error, message: "Unexpected type", atFunction: #function, inFile: #file)
			}
		})
	}

	func setupDefaultProperties() {
		/* frameName */
		definePropertyType(propertyName: FrameNameItem, valueType: .stringType)
		setStringValue(name: FrameNameItem, value: ALConfig.defaultFrameName)

		/* value(name: string) */
		definePropertyType(propertyName: ValueItem, valueType: .functionType(.anyType, [.stringType]))
		let valuefunc: @convention(block) (_ name: JSValue) -> JSValue = {
			(_ name: JSValue) -> JSValue in
			let retval = core.value(name)
			return retval
		}
		if let funcval = JSValue(object: valuefunc, in: core.context) {
			setValue(name: ValueItem, value: funcval)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate function", atFunction: #function, inFile: #file)
		}

		/* setValue(name: string, value: any) */
		definePropertyType(propertyName: SetValueItem, valueType: .functionType(.boolType, [.stringType, .anyType]))
		let setvaluefunc: @convention(block) (_ name: JSValue, _ srcval: JSValue) -> JSValue = {
			(_ name: JSValue, _ srcval: JSValue) -> JSValue in
			return core.setValue(name, srcval)
		}
		if let funcval = JSValue(object: setvaluefunc, in: core.context) {
			setValue(name: SetValueItem, value: funcval)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate function", atFunction: #function, inFile: #file)
		}

		/* Property names: string[] */
		definePropertyType(propertyName: PropertyNamesItem, valueType: .arrayType(.stringType))
		setArrayValue(name: PropertyNamesItem, value: propertyNames)
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
		super.init()

		mFrameCore.owner = self
	}

	public func setup(resource res: KEResource) -> NSError? {
		self.setupDefaultProperties()
		return nil
	}
}

