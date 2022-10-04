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
		switch compile(scriptFile: config.scriptFile, config: lconf, outputFormat: config.outputFormat) {
		case .success(let txt):
			switch config.outputFormat {
			case .JavaScript:
				outputScript(config: config, text: txt, console: console)
			case .TypeScript:
				outputScript(config: config, text: txt, console: console)
			case .TypeDeclaration:
				executeScript(config: config, text: txt, console: console, language: lconf)
			}
		case .failure(let err):
			console.error(string: "[Error] " + err.toString())
		}
	}
}

private func executeScript(config conf: Config, text txt: CNText, console cons: CNFileConsole, language lconf: ALConfig)
{
	switch execute(script: txt, console: cons) {
	case .success(let frame):
		outputDeclaration(config: conf, frame: frame, console: cons, language: lconf)
	case .failure(let err):
		cons.error(string: "[Error] " + err.toString())
	}
}

private func outputScript(config conf: Config, text txt: CNText, console cons: CNFileConsole)
{
	switch conf.outputFileName() {
	case .success(let filename):
		if let file = CNFile.open(access: .writer, for: URL(fileURLWithPath: filename)) {
			let str = txt.toStrings().joined(separator: "\n") + "\n"
			file.put(string: str)
		} else {
			cons.print(string: "[Error] Failed to write file: \(filename)\n")
		}
	case .failure(let err):
		cons.print(string: "[Error] \(err.toString())\n")
	}
}

private func outputDeclaration(config conf: Config, frame frm: ALFrame, console cons: CNFileConsole, language lconf: ALConfig)
{
	switch conf.outputFileName() {
	case .success(let filename):
		if let file = CNFile.open(access: .writer, for: URL(fileURLWithPath: filename)) {
			let generator = ALTypeDeclGenerator(config: lconf)
			let txt = generator.generateTypeDeclaration(frame: frm)
			let str = txt.toStrings().joined(separator: "\n") + "\n"
			file.put(string: str)
		} else {
			cons.print(string: "[Error] Failed to write file: \(filename)\n")
		}
	case .failure(let err):
		cons.print(string: "[Error] \(err.toString())\n")
	}
}

main(arguments: CommandLine.arguments)

