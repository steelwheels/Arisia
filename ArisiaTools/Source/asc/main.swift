/**
 * @file	main..swift
 * @brief	Main function for asc command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

func main(arguments args: Array<String>) {
	let console = CNFileConsole()
	let cmdline = CommandLineParser(console: console)
	if let (config, subargs) = cmdline.parseArguments(arguments: Array(args.dropFirst())) {
		for script in config.scriptFiles {
			console.print(string: "script: \(script)\n")
		}
		for subarg in subargs {
			console.print(string: "subarg: \(subarg)\n")
		}
	}
}

main(arguments: CommandLine.arguments)

