/**
 * @file	ALFrameCore.swift
 * @brief	Define ALFrameCore class
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
	func _value(_ name: JSValue) -> JSValue
	func _setValue(_ name: JSValue, _ val: JSValue) -> JSValue 	// -> boolean
	func _definePropertyType(_ property: JSValue, _ type: JSValue)
	func _addObserver(_ property: JSValue, _ cbfunc: JSValue)
}


@objc public class ALFrameCore: NSObject, ALFrameCoreProtorol
{
	public typealias ListnerHolder = CNObserverDictionary.ListnerHolder

	private var mFrameName:		String
	private var mPropertyTypes:	Dictionary<String, CNValueType>	// <property-name, value-type>
	private var mPropertyNames:	Array<String>
	private var mPropertyValues:	CNObserverDictionary
	private var mPropertyListners:	Array<ListnerHolder>
	private var mContext:		KEContext

	public var owner: 		AnyObject?

	public init(frameName cname: String, context ctxt: KEContext){
		mFrameName		= cname
		mPropertyTypes		= [:]
		mPropertyNames		= []
		mPropertyValues		= CNObserverDictionary()
		mPropertyListners	= []
		mContext		= ctxt
		owner			= nil
	}

	deinit {
		for listner in mPropertyListners {
			mPropertyValues.removeObserver(listnerHolder: listner)
		}
	}

	public var context: KEContext { get {
		return mContext
	}}

	public var frameName: String { get {
		return mFrameName
	}}

	public var propertyNames: Array<String> { get {
		return mPropertyNames
	}}

	public func propertyType(propertyName pname: String) -> CNValueType? {
		return mPropertyTypes[pname]
	}

	public func _value(_ name: JSValue) -> JSValue {
		if let namestr = name.toString() {
			if let val = value(name: namestr) {
				return val
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func _setValue(_ name: JSValue, _ val: JSValue) -> JSValue {
		let result: Bool
		/* Add property name if it is not defined */
		if let namestr = name.toString() {
			setValue(name: namestr, value: val)
			result = true
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func value(name nm: String) -> JSValue? {
		if let val = mPropertyValues.value(forKey: nm) as? JSValue {
			return val
		} else {
			return nil
		}
	}

	public func setValue(name nm: String, value val: JSValue) {
		addPropertyName(name: nm)
		mPropertyValues.setValue(val, forKey: nm)
	}

	public func _definePropertyType(_ property: JSValue, _ type: JSValue) {
		if let pname = property.toString(), let tcode = type.toString() {
			definePropertyType(propertyName: pname, typeCode: tcode)
		} else {
			CNLog(logLevel: .error, message: "Invalid \"property\" or \"type\" parameter for define property method")
		}
	}

	public func definePropertyType(propertyName pname: String, typeCode tcode: String) {
		switch CNValueType.decode(code: tcode) {
		case .success(let vtype):
			definePropertyType(propertyName: pname, valueType: vtype)
		case .failure(let err):
			CNLog(logLevel: .error, message: err.toString())
		}
	}

	public func definePropertyTypes(propertyTypes ptypes: Dictionary<String, CNValueType>) {
		for (name, type) in ptypes {
			definePropertyType(propertyName: name, valueType: type)
		}
	}

	public func definePropertyType(propertyName nm: String, valueType vtype: CNValueType) {
		addPropertyName(name: nm)
		mPropertyTypes[nm] = vtype
	}

	private func addPropertyName(name nm: String) {
		if let _ = mPropertyNames.firstIndex(where: { $0 == nm }) {
			/* Already defined */
		} else {
			mPropertyNames.append(nm)
		}
	}

	public func _addObserver(_ property: JSValue, _ cbfunc: JSValue) {
		if let pname = property.toString() {
			addPropertyObserver(propertyName: pname,  listnerFunction: {
				(_ param: Any?) -> Void in cbfunc.call(withArguments: [])
			})
		} else {
			CNLog(logLevel: .error, message: "Invalid \"property\" parameter for _addObserver method")
		}
	}

	public func addPropertyObserver(propertyName pname: String, listnerFunction lfunc: @escaping CNObserverDictionary.ListenerFunction) {
		mPropertyListners.append(
			mPropertyValues.addObserver(forKey: pname, listnerFunction: lfunc)
		)
	}
}
