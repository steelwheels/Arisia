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
	public var rootInstanceName: 	String
	public var rootClassName:	String

	/* Type declarations */
	public var coreFrameInterface:	String

	public override init(applicationType atype: KEApplicationType, doStrict strict: Bool, logLevel log: CNConfig.LogLevel) {
		self.rootInstanceName	= "root"
		switch atype {
		case .terminal:
			self.rootClassName = "Frame"
		case .window:
			self.rootClassName = "RootView"
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown application type", atFunction: #function, inFile: #file)
			self.rootClassName = "Frame"
		}
		self.coreFrameInterface	= "FrameCoreIF"
		super.init(applicationType: atype, doStrict: strict, logLevel: log)
	}
}

