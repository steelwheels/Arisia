/**
 * @file	ALFrameIR.swift
 * @brief	Define ALFrameIR class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import Foundation

public class ALFrameIR
{
	public struct Property {
		var name:	String
		var value:	ALValueIR
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

	public func set(property prop: Property){
		mMembers.append(prop)
		mDictionary[prop.name] = prop.value
	}

	public func value(name nm: String) -> ALValueIR? {
		return mDictionary[nm]
	}
}
