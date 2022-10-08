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

public func compile(context ctxt: KEContext, scriptFile file: String, outputFormat format: Config.Format, resource res: KEResource, config conf: ALConfig, console cons: CNFileConsole) -> Result<CNText, NSError>
{
	
	let procmgr  = CNProcessManager()
	let terminfo = CNTerminalInfo(width: 80, height: 20)
	let env      = CNEnvironment()
	let config   = ALConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)

	/* Prepare libraries */
	let compiler = AMLibraryCompiler()
	guard compiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: config) else {
		return .failure(NSError.fileError(message: "Arisia library error"))
	}

	let result = CNTextSection()
	if format == .TypeScript {
		result.add(text: CNTextLine(string: "/// <reference path=\"types/ArisiaComponents.d.ts\" />"))

		let dconf = Config(scriptFile: file, outputFormat: .TypeDeclaration)
		switch dconf.outputFileName() {
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
	let parser   = ALParser(config: conf)
	switch parser.parse(source: script as String, sourceFile: url) {
	case .success(let frame):
		let conf     = ALConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
		let compiler = ALScriptCompiler(config: conf)
		let lang: ALLanguage
		switch format {
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

