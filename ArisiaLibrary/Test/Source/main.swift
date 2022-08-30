/**
 * @file	main.swift
 * @brief	Define testMain  function
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func testMain() {
	var results: Array<Bool> = []

	let console = CNFileConsole()
	guard let vm = JSVirtualMachine() else {
		CNLog(logLevel: .error, message: "Failed to allocate VM", atFunction: #function, inFile: #file)
		return
	}
	let context = KEContext(virtualMachine: vm)
	results.append(testCompiler(context: context, console: console))


	/* Print summary */
	var summary = true
	for res in results {
		summary = summary && res
	}
	console.print(string: "Summary: " + (summary ? "OK" : "Error") + "\n")
}

testMain()



