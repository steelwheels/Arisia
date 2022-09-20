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
	private var mConfig: ALConfig

	public init(config conf: ALConfig){
		mConfig = conf
	}

	public func generateTypeDeclaration(frame frm: ALFrame) -> CNTextSection {
		let result = CNTextSection()
		result.header = "interface \(frm.frameName) extends \(mConfig.coreFrameInterface) {"
		result.footer = "}"
		return result
	}
}

