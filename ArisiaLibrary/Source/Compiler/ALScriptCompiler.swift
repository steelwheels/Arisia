/**
 * @file	ALScriptCompiler.swift
 * @brief	Define ALScriptCompiler class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALScriptCompiler
{
	private var mLanguageConfig: ALLanguageConfig

	public init(config conf: ALLanguageConfig){
		mLanguageConfig = conf
	}

	public func compile(rootFrame frame: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		switch transpile(frame: frame) {
		case .success(let csect):
			result.add(text: csect)
			switch link(frame: frame) {
			case .success(let lsect):
				result.add(text: lsect)
				switch construct(frame: frame) {
				case .success(let csect):
					result.add(text: csect)
				case .failure(let err):
					return .failure(err)
				}

				return .success(result)
			case .failure(let err):
				return .failure(err)
			}
		case .failure(let err):
			return .failure(err)
		}
	}

	private func transpile(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let transpiler = ALScriptTranspiler(config: mLanguageConfig)
		return transpiler.transpile(frame: frm) 
	}

	private func link(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let linker = ALScriptLinker(config: mLanguageConfig)
		return linker.link(frame: frm)
	}

	private func construct(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let constructor = ALScriptConstructor(config: mLanguageConfig)
		return constructor.construct(frame: frm)
	}

	private func compileError(message msg: String) -> NSError {
		return NSError.parseError(message: msg)
	}
}

