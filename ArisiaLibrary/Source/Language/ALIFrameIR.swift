/**
 * @file	ALFrameIR.swift
 * @brief	Define ALFrameIR class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public enum ALLanguage {
	case JavaScript
	case TypeScript
	case ArisiaScript
}

public class ALFrameIR
{
	public struct Property {
		var name:	String
		var type:	CNValueType
		var value:	ALValueIR
		public init(name nm: String, type tp: CNValueType, value val: ALValueIR){
			name  = nm
			type  = tp
			value = val
		}
	}

	private var mClassName:		String
	private var mMembers:		Array<Property>
	private var mDictionary:	Dictionary<String, ALValueIR>

	public init(className cname: String) {
		mClassName	= cname
		mMembers	= []
		mDictionary	= [:]
	}

	public var className: String { get {
		return mClassName
	}}

	public var properties: Array<Property> { get {
		return mMembers
	}}

	public var propertyNames: Array<String> { get {
		return mMembers.map{ $0.name }
	}}

	public func set(property prop: Property){
		mMembers.append(prop)
		mDictionary[prop.name] = prop.value
	}

	public func value(name nm: String) -> ALValueIR? {
		return mDictionary[nm]
	}
}
