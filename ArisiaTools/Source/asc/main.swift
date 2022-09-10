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
	if let (config, _) = cmdline.parseArguments(arguments: Array(args.dropFirst())) {
		compile(scriptFiles: config.scriptFiles, console: console)
	}
}

main(arguments: CommandLine.arguments)

