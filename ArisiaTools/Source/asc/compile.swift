/**
 * @file	compile..swift
 * @brief	Compile function for asc command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import CoconutData
import Foundation

public func compile(scriptFiles files: Array<String>) -> Result<CNText, NSError>
{
	guard files.count > 0 else {
		return .failure(NSError.fileError(message: "No source file"))
	}
	let lang     = ALLanguageConfig()
	let urls     = files.map { URL(fileURLWithPath: $0) }
	let compiler = ALScriptCompiler(config: lang)
	switch compiler.compile(sourceFiles: urls) {
	case .success(let txt):
		let result = CNTextSection()
		result.add(text: CNTextLine(string: "/// <reference path=\"types/KiwiLibrary.d.ts\" />"))
		result.add(text: CNTextLine(string: "/// <reference path=\"types/ArisiaLibrary.d.ts\" />"))
		result.add(text: txt)
		return .success(txt)
	case .failure(let err):
		return .failure(err)
	}
}

