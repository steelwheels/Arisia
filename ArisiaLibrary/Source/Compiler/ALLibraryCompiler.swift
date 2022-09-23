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
		defineBuiltinFunctions(context: ctxt, console: cons)
		importBuiltinLibrary(context: ctxt, console: cons, config: conf)
		return true
	}

	private func defineBuiltinFunctions(context ctxt: KEContext, console cons: CNFileConsole) {
		/* _allocateFrame(name: string): FrameIF */
		let frameCoreFunc: @convention(block) (_ clsname: JSValue) -> JSValue = {
			(_ clsname: JSValue) -> JSValue in
			if let name = clsname.toString() {
				if let frame = ALFrameAllocator.shared.allocateFrame(className: name, context: ctxt) {
					return JSValue(object: frame.core, in: ctxt)
				} else {
					cons.error(string: "Can not allocate frame, because unknown frame name \"\(name)\" is given to _allocateFrameCore.")
				}
			} else {
				cons.error(string: "Can not allocate frame, because the parameter for _allocateFrameCore is NOT string.")
			}
			return JSValue(object: ALDefaultFrame(frameName: "Frame", context: ctxt), in: ctxt)
		}
		ctxt.set(name: "_allocateFrameCore", function: frameCoreFunc)
	}

	private func importBuiltinLibrary(context ctxt: KEContext, console cons: CNConsole, config conf: KEConfig)
	{
		/* Contacts.js depends on the Process.js */
		let libnames = ["Transpiler"]
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
