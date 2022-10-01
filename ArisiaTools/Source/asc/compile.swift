/**
 * @file	compile..swift
 * @brief	Compile function for asc command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import CoconutData
import Foundation

public func compile(scriptFiles files: Array<String>, config conf: ALConfig, language lang: ALLanguage) -> Result<CNText, NSError>
{
	guard files.count > 0 else {
		return .failure(NSError.fileError(message: "No source file"))
	}

	let result   = CNTextSection()
	if lang == .TypeScript {
		result.add(text: CNTextLine(string: "/// <reference path=\"types/KiwiLibrary.d.ts\" />"))
		result.add(text: CNTextLine(string: "/// <reference path=\"types/ArisiaLibrary.d.ts\" />"))
		result.add(text: CNTextLine(string: "/// <reference path=\"types/ArisiaComponents.d.ts\" />"))
	}
	for file in files {
		let url = URL(fileURLWithPath: file)
		guard let script = url.loadContents() else {
			return .failure(NSError.fileError(message: "Failed to read \(file)"))
		}
		let parser   = ALParser(config: conf)
		switch parser.parse(source: script as String, sourceFile: url) {
		case .success(let frame):
			let conf     = ALConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
			let compiler = ALScriptCompiler(config: conf)
			switch compiler.compile(rootFrame: frame, language: lang) {
			case .success(let txt):
				result.add(text: txt)
				return .success(result)
			case .failure(let err):
				return .failure(err)
			}
		case .failure(let err):
			return .failure(err)
		}
	}
	return .success(result)
}

