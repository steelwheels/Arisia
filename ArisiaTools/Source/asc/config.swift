/**
 * @file	config..swift
 * @brief	Define Config class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import CoconutData
import Cobalt
import Foundation

public class Config
{
	private var mScriptFiles: 	Array<String>
	private var mCompileOnly:	Bool
	private var mOutputLanguage:	ALLanguage

	public var scriptFiles: Array<String>	{ get { return mScriptFiles	}}
	public var compileOnly: Bool		{ get { return mCompileOnly 	}}
	public var language: ALLanguage		{ get { return mOutputLanguage  }}

	public init(scriptFiles files: Array<String>, compileOnly conly: Bool, language lang: ALLanguage){
		mScriptFiles	= files
		mCompileOnly	= conly
		mOutputLanguage	= lang
	}
}

public class CommandLineParser
{
	private enum OptionId: Int {
		case Help		= 0
		case Version		= 1
		case CompileOnly	= 2
		case Language		= 3
	}

	private var mConsole:	CNConsole

	public init(console cons: CNConsole){
		mConsole = cons
	}

	private func printUsage() {
		mConsole.print(string: "usage: asc [options] script-file1 ... (option \"-h\" for help)\n")
	}

	private func printHelpMessage() {
		mConsole.print(string: "usage: asc [options] script-file1 script-file2 ...\n" +
		"  [options]\n" +
		"    --compile-only, -c    : Compile only (Do not execute the script)\n" +
		"    --language, -l <lang> : The output format: \"JavaScript\" (default),\n" +
		"                            \"TypeScript\" or \"ArisiaScript\"\n" +
		"    --help, -h            : Print this message\n" +
		"    --version             : Print version\n"
		)
	}

	public func parseArguments(arguments args: Array<String>) -> (Config, Array<String>)? {
		var config : Config? = nil
		let (err, _, rets, subargs) = CBParseArguments(parserConfig: parserConfig(), arguments: args)
		if let e = err {
			mConsole.error(string: "[Error] \(e.description)\n")
		} else {
			config = parseOptions(arguments: rets)
		}
		if let config = config {
			return (config, subargs)
		} else {
			return nil
		}
	}

	private func parseOptions(arguments args: Array<CBArgument>) -> Config? {
		var files: Array<String>		= []
		var compileonly: Bool			= false
		var language: ALLanguage		= .JavaScript
		let stream   = CNArrayStream(source: args)
		while let arg = stream.get() {
			if let opt = arg as? CBOptionArgument {
				if let optid = OptionId(rawValue: opt.optionType.optionId) {
					switch optid {
					case .Help:
						printHelpMessage()
						return nil
					case .Version:
						printVersionMessage()
						return nil
					case .CompileOnly:
						compileonly = true
					case .Language:
						if let lang = parseLanguageOption(values: opt.parameters) {
							language = lang
						} else {
							return nil
						}
					}
				} else {
					mConsole.error(string: "[Error] Unknown command line option id")
				}
			} else if let param = arg as? CBNormalArgument {
				files.append(param.argument)
			} else {
				mConsole.error(string: "[Error] Unknown command line parameter: \(arg)")
				return nil
			}
		}
		return Config(scriptFiles: files, compileOnly: compileonly, language: language)
	}

	private func parserConfig() -> CBParserConfig {
		let opttypes: Array<CBOptionType> = [
			CBOptionType(optionId: OptionId.Help.rawValue,
				     shortName: "h", longName: "help",
				     parameterNum: 0, parameterType: .voidType,
				     helpInfo: "Print help message and exit program"),
			CBOptionType(optionId: OptionId.Version.rawValue,
				     shortName: nil, longName: "version",
				     parameterNum: 0, parameterType: .voidType,
				     helpInfo: "Print version information"),
			CBOptionType(optionId: OptionId.CompileOnly.rawValue,
				     shortName: "c", longName: "compile-only",
				     parameterNum: 0, parameterType: .voidType,
				     helpInfo: "Output the compiled code, not execute it"),
			CBOptionType(optionId: OptionId.Language.rawValue,
				     shortName: "l", longName: "language",
				     parameterNum: 1, parameterType: .stringType,
				     helpInfo: "Output language, \"JavaScript\" or \"TypeScript\""),
		]
		let config = CBParserConfig(hasSubCommand: false)
		config.setDefaultOptions(optionTypes: opttypes)
		return config
	}

	private func parseLanguageOption(values vals: Array<CBValue>) -> ALLanguage? {
		let result: ALLanguage?
		switch vals.count {
		case 1:
			if let lang = parseLanguageOption(value: vals[0]) {
				result = lang
			} else {
				mConsole.print(string: "[Error] Give parameter \"JavaScript\" or \"TypeScript\" for language option")
				result = nil
			}
		case 0:
			mConsole.print(string: "[Error] Give parameter \"JavaScript\" or \"TypeScript\" for language option")
			result = nil
		default:
			mConsole.print(string: "[Error] Too many parameter for language option")
			result = nil
		}
		return result
	}

	private func parseLanguageOption(value val: CBValue) -> ALLanguage? {
		let result: ALLanguage?
		switch val {
		case .stringValue(let str):
			switch str {
			case "JavaScript":	result = .JavaScript
			case "TypeScript":	result = .TypeScript
			default:		result = nil
			}
		default:
			result = nil
		}
		return result
	}

	private func printVersionMessage() {
		let plist = CNPropertyList(bundleDirectoryName: "ArisiaTools.bundle")
		let version: String
		if let v = plist.version {
			version = v
		} else {
			version = "<Unknown>"
		}
		mConsole.print(string: "\(version)\n")
	}
}
