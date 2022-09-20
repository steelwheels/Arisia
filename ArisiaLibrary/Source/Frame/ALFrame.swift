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

@objc public protocol ALFrameProtorol: JSExport
{
	var propertyNames: JSValue { get }

	func value(_ name: JSValue) -> JSValue
	func setValue(_ name: JSValue, _ val: JSValue) -> JSValue 	// -> boolean

	func definePropertyType(_ property: JSValue, _ type: JSValue)	// (property: sttring, type: string)
	func addObserver(_ property: JSValue, _ cbfunc: JSValue)	// (property: string, cbfunc: ():void)
}

@objc public class ALFrame: NSObject, ALFrameProtorol
{
	public typealias ListnerHolder = CNObserverDictionary.ListnerHolder

	private var mFrameName:		String
	private var mPropertyTypes:	Dictionary<String, CNValueType>	// <property-name, value-type>
	private var mPropertyValues:	CNObserverDictionary
	private var mPropertyListners:	Array<ListnerHolder>
	private var mContext:		KEContext

	public init(frameName cname: String, context ctxt: KEContext){
		mFrameName		= cname
		mPropertyTypes		= [:]
		mPropertyValues		= CNObserverDictionary()
		mPropertyListners	= []
		mContext		= ctxt
	}

	deinit {
		for listner in mPropertyListners {
			mPropertyValues.removeObserver(listnerHolder: listner)
		}
	}

	public var frameName: String { get {
		return mFrameName
	}}

	public var propertyNames: JSValue { get {
		return JSValue(object: mPropertyValues.keys, in: mContext)

	}}

	public func value(_ name: JSValue) -> JSValue {
		if let namestr = name.toString() {
			if let val = mPropertyValues.value(forKey: namestr) as? JSValue {
				return val
			}
		}
		return JSValue(nullIn: mContext)
	}

	public func setValue(_ name: JSValue, _ val: JSValue) -> JSValue {
		let result: Bool
		if let namestr = name.toString() {
			mPropertyValues.setValue(val, forKey: namestr)
			result = true
		} else {
			result = false
		}
		return JSValue(bool: result, in: mContext)
	}

	public func definePropertyType(_ property: JSValue, _ type: JSValue) {
		guard let pname = property.toString(), let ptypestr = type.toString() else {
			CNLog(logLevel: .error, message: "Invalid \"property\" or \"type\" parameter for define property method")
			return
		}
		switch CNValueType.decode(code: ptypestr) {
		case .success(let vtype):
			mPropertyTypes[pname] = vtype
		case .failure(let err):
			CNLog(logLevel: .error, message: err.toString())
		}
	}

	public func addObserver(_ property: JSValue, _ cbfunc: JSValue) {
		guard let propstr = property.toString() else {
			CNLog(logLevel: .error, message: "Invalid \"property\" parameter for addObserver method")
			return
		}
		/* Add function as a listner */
		mPropertyListners.append(
			mPropertyValues.addObserver(forKey: propstr, listnerFunction: {
				(_ param: Any?) -> Void in cbfunc.call(withArguments: [])
			})
		)
	}
}
