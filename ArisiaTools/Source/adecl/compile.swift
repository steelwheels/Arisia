/**
 * @file compile..swift
 * @brief	Define compile function
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaComponents
import ArisiaLibrary
import KiwiLibrary
import KiwiEngine
import CoconutData
import Foundation

public func compile(context ctxt: KEContext, resource res: KEResource, config conf: ALConfig, console cons: CNFileConsole) -> Bool
{
	
	let procmgr    = CNProcessManager()
	let terminfo   = CNTerminalInfo(width: 80, height: 20)
	let env        = CNEnvironment()
	let amcompiler = AMLibraryCompiler()
	guard amcompiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
		return false
	}
	return true
}
