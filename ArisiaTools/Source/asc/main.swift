/**
 * @file	main..swift
 * @brief	Main function for asc command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaComponents
import ArisiaLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

func main(arguments args: Array<String>) {
	let console = CNFileConsole()
	let cmdline = CommandLineParser(console: console)
	guard let (config, _) = cmdline.parseArguments(arguments: Array(args.dropFirst())) else {
		return
	}

	/* Define dummy builtin components */
	defineBuiltinComponents()

	/* Load script */
	let srcurl = URL(fileURLWithPath: config.scriptFile)
	let lconf  = ALConfig(applicationType: config.target, doStrict: true, logLevel: .defaultLevel)
	guard let source = srcurl.loadContents() as String? else {
		console.print(string: "[Error] Failed to load source from \(srcurl.path)")
		return
	}

	/* Parse script */
	let parser = ALParser(config: lconf)
	let rootfrm: ALFrameIR
	switch parser.parse(source: source, sourceFile: srcurl) {
	case .success(let frm):
		rootfrm = frm
	case .failure(let err):
		console.print(string: "[Error] Parse error: \(err.toString())")
		return
	}

	/* Analuze script */
	let analyzer = ALScriptAnalyzer(config: lconf)
	if let err = analyzer.anayze(frame: rootfrm) {
		console.print(string: "[Error] Analyze error: \(err.toString())")
		return
	}

	/* Select output */
	let output: CNTextSection
	switch config.outputFormat {
	case .JavaScript:
		switch generateScript(rootFrame: rootfrm, language: .JavaScript, config: lconf) {
		case .success(let txt):
			output = txt
		case .failure(let err):
			console.print(string: "[Error] Failed to generate JavaScript: \(err.toString())")
			return
		}
 	case .TypeScript:
		let text = CNTextSection()
		text.add(text: generateReference(config: config))
		switch generateScript(rootFrame: rootfrm, language: .TypeScript, config: lconf) {
		case .success(let txt):
			text.add(text: txt)
		case .failure(let err):
			console.print(string: "[Error] Failed to generate TypeScript: \(err.toString())\n")
			return
		}
		output = text
	case .TypeDeclaration:
		let path      = ALFramePath(path: [], instanceName: lconf.rootInstanceName, frameName: lconf.rootFrameName)
		let generator = ALTypeDeclGenerator(config: lconf)
		switch generator.generateTypeDeclaration(path: path, frame: rootfrm) {
		case .success(let txt):
			output = txt
		case .failure(let err):
			console.print(string: "[Error] Failed to generate declaration: \(err.toString())\n")
			return
		}
	}

	outputScript(config: config, text: output, console: console)
}

private func generateScript(rootFrame root: ALFrameIR, language lang: ALLanguage, config conf: ALConfig) -> Result<CNTextSection, NSError>
{
	let compiler = ALScriptCompiler(config: conf)
	switch compiler.compile(rootFrame: root, language: lang) {
	case .success(let text):
		return .success(text)
	case .failure(let err):
		return .failure(err)
	}
}

private func generateReference(config conf: Config) -> CNTextSection
{
	var files: Array<String> = ["types/ArisiaPlatform.d.ts"]
	files.append(contentsOf: conf.importFiles)

	/* Add reference for <script-file>-if.d.ts */
	let scrfile = conf.scriptFile as NSString
	let scrbody = scrfile.deletingPathExtension
	files.append("types/\(scrbody)-if.d.ts")

	let result = CNTextSection()
	for file in files {
		let line = CNTextLine(string: "/// <reference path=\"\(file)\"/>")
		result.add(text: line)
	}
	return result
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

main(arguments: CommandLine.arguments)

