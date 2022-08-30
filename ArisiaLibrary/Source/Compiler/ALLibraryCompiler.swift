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

public class ALLibraryCompiler: KECompiler
{
	public func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		defineFrameCore(context: ctxt)
		importBuiltinLibrary(context: ctxt, console: cons, config: conf)
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

	private func importBuiltinLibrary(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig)
	{
		/* Contacts.js depends on the Process.js */
		let libnames = ["Frame"]
		do {
			for libname in libnames {
				if let url = CNFilePath.URLForResourceFile(fileName: libname, fileExtension: "js", subdirectory: "Library", forClass: ALLibraryCompiler.self) {
					let script = try String(contentsOf: url, encoding: .utf8)
					let _ = compileStatement(context: ctxt, statement: script, sourceFile: url, console: cons, config: conf)
				} else {
					cons.error(string: "Built-in script \"\(libname)\" is not found.")
				}
			}
		} catch {
			cons.error(string: "Failed to read built-in script in ArisiaLibrary")
		}
	}
}
