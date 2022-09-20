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

	public func compile(sourceFiles srcs: Array<URL>) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		for src in srcs {
			if let scr = src.loadContents() {
				switch compile(sourceScript: scr as String, sourceFile: src) {
				case .success(let newtxt):
					result.add(text: newtxt)
				case .failure(let err):
					return .failure(err)
				}
			} else {
				return .failure(compileError(message: "Failed to read \(src.path)"))
			}
		}
		return .success(result)
	}

	public func compile(sourceScript src: String, sourceFile file: URL?) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		let parser = ALParser()
		switch parser.parse(source: src, sourceFile: file) {
		case .success(let frame):
			switch compile(frame: frame) {
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
		case .failure(let err):
			return .failure(err)
		}
	}

	public func compile(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let transpiler = ALScriptTranspiler(config: mLanguageConfig)
		return transpiler.transpile(frame: frm) 
	}

	public func link(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let linker = ALScriptLinker(config: mLanguageConfig)
		return linker.link(frame: frm)
	}

	public func construct(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let constructor = ALScriptConstructor(config: mLanguageConfig)
		return constructor.construct(frame: frm)
	}

	private func compileError(message msg: String) -> NSError {
		return NSError.parseError(message: msg)
	}
}

