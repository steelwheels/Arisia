/**
 * @file	KMThreadLauncher.swift
 * @brief	Define KMThreadLauncher class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiShell
import KiwiLibrary
import KiwiEngine
import CoconutData
import Foundation

public class AMThreadLauncher: KLThreadLauncher
{
	private var mViewController: AMComponentViewController

	public init(viewController vcont: AMComponentViewController, context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig) {
		mViewController = vcont
		super.init(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, config: conf)
	}

	open override func allocateThread(source src: KLSource, processManager procmgr: CNProcessManager, input ifile: CNFile, output ofile: CNFile, error efile: CNFile, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig) -> KLThread {
		let result = AMScriptThread(viewController: mViewController, source: src, processManager: procmgr, input: ifile, output: ofile, error: efile, terminalInfo: terminfo, environment: env, config: conf)
		return result
	}
}
