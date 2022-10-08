/**
 * @file	ALFrameIR.swift
 * @brief	Define ALFrameIR class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public enum ALLanguage
{
	case JavaScript
	case TypeScript
	case ArisiaScript

	public func encode() -> String {
		let result: String
		switch self {
		case .JavaScript:	result = "JavaScript"
		case .TypeScript:	result = "TypeScript"
		case .ArisiaScript:	result = "ArisiaScript"
		}
		return result
	}

	public static func decode(languageName name: String) -> ALLanguage? {
		let result: ALLanguage?
		switch name {
		case "JavaScript":	result = .JavaScript
		case "TypeScript":	result = .TypeScript
		case "ArisiaScript":	result = .ArisiaScript
		default:		result = nil
		}
		return result
	}
}

public class ALFrameIR
{
	public struct Property {
		var name:	String
		var value:	ALValueIR

		public var type: CNValueType { get { return value.toType() }}

		public init(name nm: String, value val: ALValueIR){
			name  = nm
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

	public func property(name nm: String) -> Property? {
		for memb in mMembers {
			if memb.name == nm {
				return memb
			}
		}
		return nil
	}

	public func set(property prop: Property){
		mMembers.append(prop)
		mDictionary[prop.name] = prop.value
	}

	public func remove(name nm: String) -> Bool {
		for i in 0..<mMembers.count {
			let prop = mMembers[i]
			if prop.name == nm {
				mMembers.remove(at: i)
				mDictionary[nm] = nil
				return true
			}
		}
		return false
	}

	public func value(name nm: String) -> ALValueIR? {
		return mDictionary[nm]
	}
}
