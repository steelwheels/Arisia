/**
 * @file	ALFrame.swift
 * @brief	Define ALFrame class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import KiwiLibrary
import JavaScriptCore
import Foundation

@objc public protocol ALFrameCoreProtorol: JSExport
{
	var propertyNames: JSValue { get }

	func get(_ name: JSValue) -> JSValue
	func set(_ name: JSValue, _ val: JSValue) -> JSValue // -> boolean
}

@objc public class ALFrameCore: NSObject, ALFrameCoreProtorol
{
	private var mPropertyValues:	CNObserverDictionary
	private var mContext:		KEContext

	public init(context ctxt: KEContext){
		mPropertyValues	= CNObserverDictionary()
		mContext	= ctxt
	}

	public var propertyNames: JSValue { get {
		return JSValue(object: mPropertyValues.keys, in: mContext)

	}}

	public func get(_ name: JSValue) -> JSValue {
		if let namestr = name.toString() {
			if let val = mPropertyValues.value(forKey: namestr) as? JSValue {
				return val
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func set(_ name: JSValue, _ val: JSValue) -> JSValue {
		let result: Bool
		if let namestr = name.toString() {
			mPropertyValues.setValue(val, forKey: namestr)
			result = true
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}
}


/*
/**
 * @file	AMBReactObject.swift
 * @brief	Define AMBReactObject class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import KiwiEngine
import KiwiLibrary
import CoconutData
import JavaScriptCore

@objc public protocol AMBObjectInterface: JSExport {
	func get(_ name: JSValue) -> JSValue
	func set(_ name: JSValue, _ val: JSValue) -> JSValue // return: bool

	var description: String { get }
}

@objc public class AMBReactObject: NSObject, AMBObjectInterface
{
	public typealias ListnerHolder = CNObserverDictionary.ListnerHolder

	private var mFrame:			AMBFrame
	private var mContext:			KEContext
	private var mProcessManager:		CNProcessManager
	private var mResource:			KEResource
	private var mEnvironment:		CNEnvironment
	private var mPropertyValues:		CNObserverDictionary
	private var mPropertyListners:		Array<ListnerHolder>
	private var mListerFuncPointers:	Dictionary<String, Array<AMBObjectPointer>>
	private var mScriptedPropertyNames:	Array<String>

	public var frame:			AMBFrame 		{ get { return mFrame }}
	public var context:			KEContext 		{ get { return mContext }}
	public var processManager:		CNProcessManager	{ get { return mProcessManager }}
	public var resource:			KEResource		{ get { return mResource }}
	public var environment:			CNEnvironment		{ get { return mEnvironment }}
	public var scriptedPropertyNames:	Array<String>		{ get { return mScriptedPropertyNames }}
	public var allPropertyNames:		Array<String> 		{ get { return mPropertyValues.keys }}

	public init(frame frm: AMBFrame, context ctxt: KEContext, processManager pmgr: CNProcessManager, resource res: KEResource, environment env: CNEnvironment) {
		mFrame			= frm
		mContext		= ctxt
		mProcessManager		= pmgr
		mResource		= res
		mEnvironment		= env
		mPropertyValues		= CNObserverDictionary()
		mPropertyListners	= []
		mListerFuncPointers	= [:]
		mScriptedPropertyNames	= []
		super.init()

		/* Set default properties */
		if let inststr = JSValue(object: frame.instanceName, in: ctxt) {
			setImmediateValue(value: inststr, forProperty: "instanceName")
		}
		if let clsstr = JSValue(object: frame.className, in: ctxt) {
			setImmediateValue(value: clsstr, forProperty: "className")
		}
	}

	deinit {
		for listner in mPropertyListners {
			mPropertyValues.removeObserver(listnerHolder: listner)
		}
	}

	public func addScriptedPropertyName(name nm: String) {
		mScriptedPropertyNames.append(nm)
	}

	public func get(_ name: JSValue) -> JSValue {
		if name.isString {
			if let namestr = name.toString() {
				if let val = immediateValue(forProperty: namestr) {
					return val
				}
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func set(_ name: JSValue, _ val: JSValue) -> JSValue {
		if name.isString {
			if let namestr = name.toString() {
				setImmediateValue(value: val, forProperty: namestr)
				return JSValue(bool: true, in: mContext)
			}
		}
		return JSValue(bool: false, in: mContext)
	}

	public override var description: String {
		get {
			let clsname = mFrame.className
			let insname = mFrame.instanceName
			let desc    = "component: { class:\(clsname), instance=\(insname) }"
			return desc
		}
	}

	public func hasValue(forProperty prop: String) -> Bool {
		if let _ = mPropertyValues.value(forKey: prop) {
			return true
		} else {
			return false
		}
	}

	public func immediateValue(forProperty prop: String) -> JSValue? {
		if let val = mPropertyValues.value(forKey: prop) as? JSValue {
			return val
		} else {
			return nil
		}
	}

	public func setImmediateValue(value val: JSValue, forProperty prop: String) {
		mPropertyValues.setValue(val, forKey: prop)
	}

	public func boolValue(forProperty prop: String) -> Bool? {
		if let imm = immediateValue(forProperty: prop) {
			if imm.isBoolean {
				return imm.toBool()
			}
		}
		return nil
	}

	public func setBoolValue(value val: Bool, forProperty prop: String) {
		if let curval = boolValue(forProperty: prop) {
			if curval == val {
				return // already defined
			}
		}
		if let val = JSValue(bool: val, in: self.context) {
			setImmediateValue(value: val, forProperty: prop)
		} else {
			NSLog("Failed to allocate bool value")
		}
	}

	public func int32Value(forProperty prop: String) -> Int32? {
		if let imm = immediateValue(forProperty: prop) {
			if imm.isNumber {
				return imm.toInt32()
			}
		}
		return nil
	}

	public func setInt32Value(value val: Int32, forProperty prop: String) {
		if let curval = int32Value(forProperty: prop) {
			if curval == val {
				return // already defined
			}
		}
		if let val = JSValue(int32: val , in: self.context) {
			setImmediateValue(value: val, forProperty: prop)
		} else {
			NSLog("Failed to allocate int32 value")
		}
	}

	public func floatValue(forProperty prop: String) -> Double? {
		if let imm = immediateValue(forProperty: prop) {
			if imm.isNumber {
				return imm.toDouble()
			}
		}
		return nil
	}

	public func setFloatValue(value val: Double, forProperty prop: String) {
		if let curval = floatValue(forProperty: prop) {
			if curval == val {
				return // already defined
			}
		}
		if let val = JSValue(double: val, in: self.context) {
			setImmediateValue(value: val, forProperty: prop)
		} else {
			NSLog("Failed to allocate int32 value")
		}
	}

	public func numberValue(forProperty prop: String) -> NSNumber? {
		if let imm = immediateValue(forProperty: prop) {
			if imm.isNumber {
				return imm.toNumber()
			}
		}
		return nil
	}

	public func setNumberValue(value val: NSNumber, forProperty prop: String) {
		if let curval = numberValue(forProperty: prop) {
			switch curval.compare(val) {
			case .orderedSame:
				return // already defined
			case .orderedAscending, .orderedDescending:
				break
			}
		}
		if let val = JSValue(object: val, in: self.context) {
			setImmediateValue(value: val, forProperty: prop)
		} else {
			NSLog("Failed to allocate number value")
		}
	}

	public func stringValue(forProperty prop: String) -> String? {
		if let imm = immediateValue(forProperty: prop) {
			if imm.isString {
				return imm.toString()
			}
		}
		return nil
	}

	public func setStringValue(value val: String, forProperty prop: String) {
		if let curval = stringValue(forProperty: prop) {
			if curval == val {
				return // already defined
			}
		}
		if let val = JSValue(object: val, in: self.context) {
			setImmediateValue(value: val, forProperty: prop)
		} else {
			NSLog("Failed to allocate string value")
		}
	}

	public func arrayValue(forProperty prop: String) -> Array<Any>? {
		if let imm = immediateValue(forProperty: prop) {
			return imm.toArray()
		} else {
			return nil
		}
	}

	public func setArrayValue(value arr: Array<CNValue>, forProperty prop: String) {
		let arrobj = CNValue.arrayValue(arr).toJSValue(context: self.context)
		setImmediateValue(value: arrobj, forProperty: prop)
	}

	public func dictionaryValue(forProperty prop: String) -> Dictionary<AnyHashable, Any>? {
		if let imm = immediateValue(forProperty: prop) {
			return imm.toDictionary()
		} else {
			return nil
		}
	}

	public func setDictionaryValue(value dict: Dictionary<String, CNValue>, forProperty prop: String) {
		let dictobj = CNValue.dictionaryValue(dict).toJSValue(context: self.context)
		setImmediateValue(value: dictobj, forProperty: prop)
	}

	public func objectValue(forProperty prop: String) -> NSObject? {
		if let imm = immediateValue(forProperty: prop) {
			if imm.isObject {
				return imm.toObject() as? NSObject
			}
		}
		return nil
	}

	public func setObjectValue(value obj: NSObject, forProperty prop: String) {
		if let val = JSValue(object: obj, in: self.context) {
			setImmediateValue(value: val, forProperty: prop)
		} else {
			NSLog("Failed to allocate object value")
		}
	}

	public func childFrame(forProperty prop: String) -> AMBReactObject? {
		if let imm = immediateValue(forProperty: prop) {
			if imm.isObject {
				if let obj = imm.toObject() as? AMBReactObject {
					return obj
				}
			}
		}
		return nil
	}

	public func setChildFrame(forProperty prop: String, frame frm: AMBReactObject) {
		setImmediateValue(value: JSValue(object: frm, in: mContext), forProperty: prop)
	}

	public func setListnerFunctionValue(value fval: JSValue, forProperty prop: String) {
		setImmediateValue(value: fval, forProperty: "_lfunc_" + prop)
	}

	public func listnerFuntionValue(forProperty prop: String) -> JSValue? {
		if let obj = immediateValue(forProperty: "_lfunc_" + prop) {
			return obj
		} else {
			return nil
		}
	}

	public func setListnerFuncPointers(pointers ptrs: Array<AMBObjectPointer>, forProperty prop: String) {
		let lname = propertyToListnerFuncParameterName(prop)
		mListerFuncPointers[lname] = ptrs
	}

	public func listnerFuncPointers(forProperty prop: String) -> Array<AMBObjectPointer>? {
		let lname = propertyToListnerFuncParameterName(prop)
		if let params = mListerFuncPointers[lname] {
			return params
		} else {
			return nil
		}
	}

	public func initListnerReturnValue(forProperty prop: String) {
		setImmediateValue(value: JSValue(nullIn: mContext), forProperty: prop)
	}

	private func propertyToListnerFuncParameterName(_ name: String) -> String {
		return "_lparam_" + name
	}

	public func addObserver(forProperty prop: String, callback cbfunc: @escaping CNObserverDictionary.ListenerFunction) {
		mPropertyListners.append(
			mPropertyValues.addObserver(forKey: prop, listnerFunction: cbfunc)
		)
	}

	public func toText() -> CNTextSection {
		let sect = CNTextSection()
		sect.header = "react-object: {"
		sect.footer = "}"

		let props = CNTextSection()
		props.header = "properties: {"
		props.footer = "}"
		for name in self.allPropertyNames {
			props.add(text: CNTextLine(string: name))
		}
		sect.add(text: props)

		return sect
	}
}

public struct AMBObjectPointer {
	public var	referenceName	: String
	public var	pointedName	: String
	public var	pointedObject	: AMBReactObject

	public func toString() -> String {
		return "{ referenceName:\(self.referenceName) pointedName=\(pointedName) pointedObject=\(pointedObject.frame.instanceName)}"
	}
}

*/
