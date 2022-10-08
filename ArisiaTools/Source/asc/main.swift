/**
 * @file	main..swift
 * @brief	Main function for asc command
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
		let ctxt     = KEContext(virtualMachine: JSVirtualMachine())
		let packdir  = URL(fileURLWithPath: "/bin", isDirectory: true)
		let resource = KEResource(packageDirectory: packdir)
		
		let lconf = ALConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
		switch compile(context: ctxt, scriptFile: config.scriptFile, outputFormat: config.outputFormat, resource: resource, config: lconf,  console: console) {
		case .success(let txt):
			switch config.outputFormat {
			case .JavaScript:
				outputScript(config: config, text: txt, console: console)
			case .TypeScript:
				outputScript(config: config, text: txt, console: console)
			case .TypeDeclaration:
				executeScript(context: ctxt, config: config, text: txt, resource: resource, console: console, language: lconf)
			}
		case .failure(let err):
			console.error(string: "[Error] " + err.toString())
		}
	}
}

private func executeScript(context ctxt: KEContext, config conf: Config, text txt: CNText, resource res: KEResource, console cons: CNFileConsole, language lconf: ALConfig)
{
	switch execute(context: ctxt, script: txt, resource: res, languageConf: lconf, console: cons) {
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

