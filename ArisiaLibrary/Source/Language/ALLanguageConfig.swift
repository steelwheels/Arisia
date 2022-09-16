/**
 * @file	ALLanguageConfig.swift
 * @brief	Define ALLanguageConfig class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import Foundation

public class ALLanguageConfig
{
	public var rootFrameName: 	String

	/* Type declarations */
	public var coreFrameInterface:	String

	public init() {
		self.rootFrameName	= "root"
		self.coreFrameInterface	= "FrameCoreIF"
	}
}

