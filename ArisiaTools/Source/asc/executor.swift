/**
 * @file	Executor..swift
 * @brief	Executor of the javascript code
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaComponents
import ArisiaLibrary
import KiwiLibrary
import KiwiEngine
import KiwiShell
import CoconutData
import JavaScriptCore
import Foundation

public func execute(context ctxt: KEContext, script scr: CNText, resource res: KEResource, config conf: Config, console cons: CNFileConsole) -> Result<ALFrame, NSError>
{
	let conf    = ALConfig(applicationType: conf.target, doStrict: true, logLevel: .defaultLevel)
	let arsexec = ALScriptExecutor(config: conf)
	if let frame = arsexec.execute(context: ctxt, script: scr, sourceFile: nil, resource: res) {
		return .success(frame)
	} else {
		return .failure(NSError.fileError(message: "Runtime error"))
	}
}

