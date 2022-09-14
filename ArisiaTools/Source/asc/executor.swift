/**
 * @file	Executor..swift
 * @brief	Executor of the javascript code
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiLibrary
import KiwiEngine
import KiwiShell
import CoconutData
import JavaScriptCore
import Foundation

public func execute(script scr: CNText, console cons: CNFileConsole) -> Result<Int32, NSError>
{
	let ctxt     = KEContext(virtualMachine: JSVirtualMachine())
	let packdir  = URL(fileURLWithPath: "/bin", isDirectory: true)
	let resource = KEResource(packageDirectory: packdir)
	let procmgr  = CNProcessManager()
	let terminfo = CNTerminalInfo(width: 80, height: 20)
	let env      = CNEnvironment()
	let config   = KEConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)

	/* Prepare libraries */
	let libcompiler = KLLibraryCompiler()
	guard libcompiler.compile(context: ctxt, resource: resource, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: config) else {
		return .failure(NSError.fileError(message: "Library error"))
	}
	let arscompiler = ALLibraryCompiler()
	guard arscompiler.compile(context: ctxt, resource: resource, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: config) else {
		return .failure(NSError.fileError(message: "Arisia library error"))
	}

	let script = scr.toStrings().joined(separator: "\n")
	ctxt.evaluateScript(script)
	return .success(0)
}

/*
private func executeScript(resource res: KEResource, processManager procmgr: CNProcessManager, input ifile: CNFile, output ofile: CNFile, error efile: CNFile, script scr: String, arguments args: Array<String>, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig) -> Int32
{
	let thread  = KHScriptThread(source: .application(res), processManager: procmgr, input: ifile, output: ofile, error: efile, terminalInfo: terminfo, environment: env, config: conf)

	/* Convert argument */
	var nargs: Array<CNValue> = []
	for arg in args {
		nargs.append(.stringValue(arg))
	}
	thread.start(argument: .arrayValue(nargs))
	while !thread.status.isRunning {
		/* wait until exit */
	}
	return thread.terminationStatus
}
*/

