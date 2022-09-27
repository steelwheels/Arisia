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
	let config   = ALConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)

	/* Prepare libraries */
	let libcompiler = KLLibraryCompiler()
	guard libcompiler.compile(context: ctxt, resource: resource, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: config) else {
		return .failure(NSError.fileError(message: "Library error"))
	}
	let arscompiler = ALLibraryCompiler()
	guard arscompiler.compile(context: ctxt, resource: resource, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: config) else {
		return .failure(NSError.fileError(message: "Arisia library error"))
	}

	let arsexec = ALScriptExecutor(config: config)
	if let _ = arsexec.execute(context: ctxt, script: scr, sourceFile: nil, resource: resource) {
		//cons.print(string: "root: \(obj)")
		return .success(0)
	} else {
		return .failure(NSError.fileError(message: "Runtime error"))
	}
}

