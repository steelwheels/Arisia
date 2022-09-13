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

	func addObjserver(_ property: JSValue, _ cbfunc: JSValue)	// (property: string, cbfunc: ():void)
}

@objc public class ALFrameCore: NSObject, ALFrameCoreProtorol
{
	public typealias ListnerHolder = CNObserverDictionary.ListnerHolder

	private var mPropertyValues:	CNObserverDictionary
	private var mPropertyListners:	Array<ListnerHolder>
	private var mContext:		KEContext

	public init(context ctxt: KEContext){
		mPropertyValues		= CNObserverDictionary()
		mPropertyListners	= []
		mContext		= ctxt
	}

	deinit {
		for listner in mPropertyListners {
			mPropertyValues.removeObserver(listnerHolder: listner)
		}
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

	public func addObjserver(_ property: JSValue, _ cbfunc: JSValue) {
		if let propstr = property.toString() {
			mPropertyListners.append(
				mPropertyValues.addObserver(forKey: propstr, listnerFunction: {
					(_ param: Any?) -> Void in cbfunc.call(withArguments: [])
				})
			)
		}
	}
}
