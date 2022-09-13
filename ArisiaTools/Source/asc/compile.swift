/**
 * @file	compile..swift
 * @brief	Compile function for asc command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import CoconutData
import Foundation

public func compile(scriptFiles files: Array<String>, console cons: CNConsole)
{
	guard files.count > 0 else {
		cons.error(string: "No source file\n")
		return
	}
	let lang     = ALLanguageConfig()
	let urls     = files.map { URL(fileURLWithPath: $0) }
	let compiler = ALScriptCompiler(config: lang)
	switch compiler.compile(sourceFiles: urls) {
	case .success(let txt):
		printHeader(console: cons)
		let str = txt.toStrings().joined(separator: "\n") + "\n"
		cons.print(string: str)
	case .failure(let err):
		cons.error(string: "[Error] " + err.toString())
	}
}

private func printHeader(console cons: CNConsole)
{
	let header = "/// <reference path=\"types/KiwiLibrary.d.ts\" />\n"
		   + "/// <reference path=\"types/ArisiaLibrary.d.ts\" />\n"
	cons.print(string: header)
}
