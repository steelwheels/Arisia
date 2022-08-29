/**
 * @file	ALLibraryCompiler.swift
 * @brief	Define ALLibraryCompiler class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class ALLibraryCompiler
{
	public func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		defineFrameCore(context: ctxt)
		return true
	}

	private func defineFrameCore(context ctxt: KEContext) {
		/* FrameCore(): FrameCoreIF */
		let frameCoreFunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let newobj = ALFrameCore(context: ctxt)
			return JSValue(object: newobj, in: ctxt)
		}
		ctxt.set(name: "FrameCore", function: frameCoreFunc)
	}
}
