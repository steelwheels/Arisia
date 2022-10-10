/**
 * @file	ALFramePathr.swift
 * @brief	Define ALFramePath class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALFramePath
{
	private var mPath:		Array<String>
	private var mInstanceName:	String
	private var mFrameName:		String

	public init(path pth: Array<String>, instanceName iname: String, frameName fname: String) {
		mPath		= pth
		mInstanceName	= iname
		mFrameName	= fname
	}

	public init() {
		mPath		= []
		mInstanceName	= "<i>"
		mFrameName	= "<f>"
	}

	public var instanceName: String { get {
		return mInstanceName
	}}

	public var fullName: String { get {
		if mPath.count > 0 {
			return mPath.joined(separator: "_") + "_" + mInstanceName
		} else {
			return mInstanceName
		}
	}}

	public var interfaceName: String { get {
		let name0 = self.fullName
		let name1 = name0.isEmpty ? "" : name0 + "_"
		return name1 + mFrameName + "IF"
	}}

	public var selfType: CNValueType { get {
		return .objectType(self.interfaceName)
	}}
}

