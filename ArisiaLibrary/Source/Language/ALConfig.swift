/**
 * @file	ALConfig.swift
 * @brief	Define ALConfig class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public class ALConfig: KEConfig
{
	static let frameClassName	= "Frame"
	static let rootViewClassName	= "RootView"

	private var mApplicationType:		KEApplicationType

	public var rootInstanceName: 		String
	public var frameInterfaceForScript:	String

	public override init(applicationType atype: KEApplicationType, doStrict strict: Bool, logLevel log: CNConfig.LogLevel) {
		self.mApplicationType = atype

		self.rootInstanceName		= "root"
		self.frameInterfaceForScript	= "FrameIF"
		super.init(applicationType: atype, doStrict: strict, logLevel: log)
	}

	public var rootClassName: String { get {
		let result: String
		switch mApplicationType {
		case .terminal:
			result = ALConfig.frameClassName
		case .window:
			result = ALConfig.rootViewClassName
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			result = ALConfig.frameClassName
		}
		return result
	}}
}

