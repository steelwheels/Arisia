/**
 * @file	main..swift
 * @brief	Main function for adecl command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

func main(arguments args: Array<String>) {
	let console = CNFileConsole()
	let cmdline = CommandLineParser(console: console)
	if let (config, _) = cmdline.parseArguments(arguments: Array(args.dropFirst())) {
		/* Load manifest file */
		let packdir  = URL(fileURLWithPath: config.packageName, isDirectory: true)
		let resource = KEResource(packageDirectory: packdir)
		let loader   = KEManifestLoader()
		if let err = loader.load(into: resource) {
			console.print(string: "[Error] \(err.toString())")
			return
		}
		/* Generate declaration */
		if let text = ALTypeDeclGenerator.generateRecordDeclaration(resource: resource) {
			console.print(string: text.toStrings().joined(separator: "\n"))
			console.print(string: "\n")
		}
	}
}

main(arguments: CommandLine.arguments)


