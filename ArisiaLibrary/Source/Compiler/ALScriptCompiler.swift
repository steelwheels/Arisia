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

	public func compile(sourceScript src: String, sourceFile file: URL) -> Result<CNTextSection, NSError> {
		let parser = ALParser()
		switch parser.parse(source: src, sourceFile: file) {
		case .success(let frame):
			return compile(frame: frame)
		case .failure(let err):
			return .failure(err)
		}
	}

	public func compile(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let transpiler = ALScriptTranspiler(config: mLanguageConfig)
		return transpiler.transpile(frame: frm) 
	}


	private func compileError(message msg: String) -> NSError {
		return NSError.parseError(message: msg)
	}
}

