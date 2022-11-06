/**
 * @file	compile..swift
 * @brief	Compile function for asc command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaComponents
import ArisiaLibrary
import KiwiEngine
import CoconutData
import Foundation

public func compile(context ctxt: KEContext, scriptFile file: String, importFiles imports: Array<String>, resource res: KEResource, config conf: Config, console cons: CNFileConsole) -> Result<CNText, NSError>
{
	let procmgr  = CNProcessManager()
	let terminfo = CNTerminalInfo(width: 80, height: 20)
	let env      = CNEnvironment()

	/* Prepare libraries */
	let compiler = AMLibraryCompiler(viewController: nil)
	let lconf    = ALConfig(applicationType: conf.target, doStrict: true, logLevel: .defaultLevel)
	guard compiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: lconf) else {
		return .failure(NSError.fileError(message: "Arisia library error"))
	}

	let result = CNTextSection()
	if conf.outputFormat == .TypeScript {
		result.add(text: CNTextLine(string: "/// <reference path=\"types/ArisiaComponents.d.ts\" />"))
		for ifile in imports {
			result.add(text: CNTextLine(string: "/// <reference path=\"\(ifile)\" />"))
		}
		switch conf.declarationFileName() {
		case .success(let dfile):
			result.add(text: CNTextLine(string: "/// <reference path=\"types/\(dfile)\" />"))
		case .failure(let err):
			return .failure(err)
		}
	}
	let url = URL(fileURLWithPath: file)
	guard let script = url.loadContents() else {
		return .failure(NSError.fileError(message: "Failed to read \(file)"))
	}
	let parser = ALParser(config: lconf)
	switch parser.parse(source: script as String, sourceFile: url) {
	case .success(let frame):
		let compiler = ALScriptCompiler(config: lconf)
		let lang: ALLanguage
		switch conf.outputFormat {
		case .JavaScript:	lang = .JavaScript
		case .TypeScript:	lang = .TypeScript
		case .TypeDeclaration:	lang = .JavaScript
		}
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

