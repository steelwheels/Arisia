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

open class ALLibraryCompiler : KLLibraryCompiler
{
	open override func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		/* Compiler for KiwiKibrary */
		guard super.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
			CNLog(logLevel: .error, message: "Failed to compile at KiwiLibrary", atFunction: #function, inFile: #file)
			return false
		}
		/* Commpile for this library */
		defineConstructorFunctions(context: ctxt, console: cons)
		importBuiltinLibrary(context: ctxt, console: cons, config: conf)
		return true
	}

	private func defineConstructorFunctions(context ctxt: KEContext, console cons: CNFileConsole) {
		let atable = ALFrameAllocator.shared
		for clsname in atable.classNames {
			if let alloc = atable.search(byClassName: clsname) {
				let allocfunc: @convention(block) () -> JSValue = {
					() -> JSValue in
					if let frame = alloc.allocFuncBody(ctxt) {
						return JSValue(object: frame.core, in: ctxt)
					} else {
						cons.error(string: "Can not allocate frame: \(clsname)")
						return JSValue(nullIn: ctxt)
					}
				}
				ctxt.set(name: alloc.allocFuncName(), function: allocfunc)
			} else {
				cons.error(string: "Unknown frame name: \(clsname)")
			}
		}
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
