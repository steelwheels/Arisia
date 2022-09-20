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
	public var rootFrameName: 	String

	/* Type declarations */
	public var coreFrameInterface:	String

	public override init(applicationType atype: KEApplicationType, doStrict strict: Bool, logLevel log: CNConfig.LogLevel) {
		self.rootFrameName	= "root"
		self.coreFrameInterface	= "FrameCoreIF"
		super.init(applicationType: atype, doStrict: strict, logLevel: log)
	}
}

