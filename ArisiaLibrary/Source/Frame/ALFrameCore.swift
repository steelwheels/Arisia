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
