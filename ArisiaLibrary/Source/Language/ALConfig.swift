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
	private static let rootWindowFrame	= "StackView"

	private var mApplicationType:		KEApplicationType

	public var rootInstanceName: 		String

	public override init(applicationType atype: KEApplicationType, doStrict strict: Bool, logLevel log: CNConfig.LogLevel) {
		self.mApplicationType = atype

		self.rootInstanceName		= "root"
		super.init(applicationType: atype, doStrict: strict, logLevel: log)
	}

	public var rootFrameName: String { get {
		return ALConfig.rootFrameName(for: mApplicationType)
	}}

	public static func rootFrameName(for atype: KEApplicationType) -> String {
		let result: String
		switch atype {
		case .terminal:
			result = ALDefaultFrame.FrameName
		case .window:
			result = ALConfig.rootWindowFrame
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			result = ALDefaultFrame.FrameName
		}
		return result
	}

}

