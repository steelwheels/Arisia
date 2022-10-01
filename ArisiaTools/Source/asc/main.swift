/**
 * @file	main..swift
 * @brief	Main function for asc command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import CoconutData
import Foundation

func main(arguments args: Array<String>) {
	let console = CNFileConsole()
	let cmdline = CommandLineParser(console: console)
	if let (config, _) = cmdline.parseArguments(arguments: Array(args.dropFirst())) {
		let lconf = ALConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
		switch compile(scriptFiles: config.scriptFiles, config: lconf, language: config.language) {
		case .success(let txt):
			if !config.compileOnly {
				switch execute(script: txt, console: console) {
				case .success(_):
					break // Finished without errors
				case .failure(let err):
					console.error(string: "[Error] " + err.toString())
				}
			} else {
				let str = txt.toStrings().joined(separator: "\n") + "\n"
				console.print(string: str)
			}
		case .failure(let err):
			console.error(string: "[Error] " + err.toString())
		}
	}
}

main(arguments: CommandLine.arguments)

