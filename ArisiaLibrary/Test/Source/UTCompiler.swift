/**
 * @file	UTCompiler.swift
 * @brief	Define UTCompiler function
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiLibrary
import KiwiEngine
import CoconutData
import Foundation

public func testCompiler(context ctxt: KEContext, console cons: CNFileConsole) -> Bool
{
	cons.print(string: "*** testCompiler\n")
	let resource = KEResource(singleFileURL: CNFilePath.URLforTempDirectory())
	let procmgr  = CNProcessManager()
	let terminfo = CNTerminalInfo(width: 80, height: 25)
	let env      = CNEnvironment()
	let conf     = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)

	let lcomp = KLLibraryCompiler()
	guard lcomp.compile(context: ctxt, resource: resource, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
		cons.print(string: "[Error] Failed to compile in KiwiLibrary\n")
		return false
	}

	let acomp = ALLibraryCompiler()
	guard acomp.compile(context: ctxt, resource: resource, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
		cons.print(string: "[Error] Failed to compile in ArisiaLibrary\n")
		return false
	}

	cons.print(string: "testCompiler ... OK\n")
	return true
}
