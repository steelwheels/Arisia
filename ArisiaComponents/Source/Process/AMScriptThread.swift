/**
 * @file	AMScriptThread.swift
 * @brief	Define AMScriptThread class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiShell
import KiwiEngine
import KiwiLibrary
import CoconutData
import Foundation

public class AMScriptThread: KLThread
{
	private var mViewController: AMComponentViewController

	public init(viewController vcont: AMComponentViewController, source src: KLSource, processManager procmgr: CNProcessManager, input ifile: CNFile, output ofile: CNFile, error efile: CNFile, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig) {
		mViewController = vcont
		super.init(source: src, processManager: procmgr, input: ifile, output: ofile, error: efile, terminalInfo: terminfo, environment: env, config: conf)
	}

	public override func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		let compiler = AMLibraryCompiler(viewController: mViewController)
		return compiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf)
	}
}

