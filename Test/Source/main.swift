/**
 * @file	main.swift
 * @brief	Define testMain  function
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public func testMain() {
	var results: Array<Bool> = []

	let console = CNFileConsole()
	results.append(testCompiler(console: console))

	/* Print summary */
	var summary = true
	for res in results {
		summary = summary && res
	}
	console.print(string: "Summary: " + (summary ? "OK" : "Error") + "\n")
}

testMain()



