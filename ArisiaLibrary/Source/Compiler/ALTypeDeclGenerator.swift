/**
 * @file	ALTypeDeclGenerator.swift
 * @brief	Define ALTypeDeclGenerator class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALTypeDeclGenerator
{
	private var mLanguageConfig: ALLanguageConfig

	public init(config conf: ALLanguageConfig){
		mLanguageConfig = conf
	}

	public func generateTypeDeclaration(frame frm: ALFrame) -> CNTextSection {
		let result = CNTextSection()
		result.header = "interface \(frm.frameName) extends \(mLanguageConfig.coreFrameInterface) {"
		result.footer = "}"
		return result
	}
}

