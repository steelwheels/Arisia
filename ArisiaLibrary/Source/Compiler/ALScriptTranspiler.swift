/**
 * @file	ALScriptTranspoler.swift
 * @brief	Define ALScriptTranspiler class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALScriptTranspiler
{
	private var mLanguageConfig: ALLanguageConfig

	public init(config conf: ALLanguageConfig){
		mLanguageConfig = conf
	}

	public func transpile(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		return transpileFrames(identifier: mLanguageConfig.rootFrameName, frame: frm)
	}

	private func transpileFrames(identifier ident: String, frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		switch transpileOneFrame(identifier: ident, frame: frm) {
		case .success(let txt):
			result.add(text: txt)
			for prop in frm.propertyNames {
				if let val = frm.value(name: prop) {
					switch val {
					case .frame(let child):
						switch transpileFrames(identifier: prop, frame: child) {
						case .success(let txt):
							result.add(text: txt)
						case .failure(let err):
							return .failure(err)
						}
					default:
						break
					}
				}
			}
		case .failure(let err):
			return .failure(err)
		}
		return .success(result)
	}

	private func transpileOneFrame(identifier ident: String, frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		let line = CNTextLine(string: "let \(ident) = _allocateFrameCore(\"\(frm.className)\") ;")
		result.add(text: line)
		return .success(result)
	}

}

