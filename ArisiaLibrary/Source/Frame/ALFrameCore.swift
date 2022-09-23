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
	var frameName: JSValue { get }
	var propertyNames: JSValue { get }

	func value(_ name: JSValue) -> JSValue
	func setValue(_ name: JSValue, _ val: JSValue) -> JSValue 	// -> boolean

	func definePropertyType(_ property: JSValue, _ type: JSValue)	// (property: sttring, type: string)
	func addObserver(_ property: JSValue, _ cbfunc: JSValue)	// (property: string, cbfunc: ():void)
}

@objc public class ALFrameCore: NSObject, ALFrameCoreProtorol
{
	public typealias ListnerHolder = CNObserverDictionary.ListnerHolder

	private var mFrameName:		String
	private var mPropertyTypes:	Dictionary<String, CNValueType>	// <property-name, value-type>
	private var mPropertyValues:	CNObserverDictionary
	private var mPropertyListners:	Array<ListnerHolder>
	private var mContext:		KEContext

	public var owner: 		AnyObject?

	public init(frameName cname: String, context ctxt: KEContext){
		mFrameName		= cname
		mPropertyTypes		= [:]
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

	public var frameName: JSValue { get {
		return JSValue(object: mFrameName, in: mContext)
	}}

	public var propertyNames: JSValue { get {
		return JSValue(object: mPropertyValues.keys, in: mContext)

	}}

	public func value(_ name: JSValue) -> JSValue {
		if let namestr = name.toString() {
			if let val = value(name: namestr) {
				return val
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func value(name nm: String) -> JSValue? {
		if let val = mPropertyValues.value(forKey: nm) as? JSValue {
			return val
		} else {
			return nil
		}
	}

	public func setValue(_ name: JSValue, _ val: JSValue) -> JSValue {
		let result: Bool
		if let namestr = name.toString() {
			setValue(name: namestr, value: val)
			result = true
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func setValue(name nm: String, value val: JSValue) {
		mPropertyValues.setValue(val, forKey: nm)
	}

	public func definePropertyType(_ property: JSValue, _ type: JSValue) {
		if let pname = property.toString(), let tcode = type.toString() {
			definePropertyType(propertyName: pname, typeCode: tcode)
		} else {
			CNLog(logLevel: .error, message: "Invalid \"property\" or \"type\" parameter for define property method")
			return
		}
	}

	public func definePropertyType(propertyName pname: String, typeCode tcode: String) {
		switch CNValueType.decode(code: tcode) {
		case .success(let vtype):
			mPropertyTypes[pname] = vtype
		case .failure(let err):
			CNLog(logLevel: .error, message: err.toString())
		}
	}

	public func definePropertyType(propertyName pname: String, valueType vtype: CNValueType) {
		mPropertyTypes[pname] = vtype
	}

	public func addObserver(_ property: JSValue, _ cbfunc: JSValue) {
		if let pname = property.toString() {
			addObserver(propertyName: pname,  listnerFunction: {
				(_ param: Any?) -> Void in cbfunc.call(withArguments: [])
			})
		} else {
			CNLog(logLevel: .error, message: "Invalid \"property\" parameter for addObserver method")
		}
	}

	public func addObserver(propertyName pname: String, listnerFunction lfunc: @escaping CNObserverDictionary.ListenerFunction) {
		mPropertyListners.append(
			mPropertyValues.addObserver(forKey: pname, listnerFunction: lfunc)
		)
	}
}
