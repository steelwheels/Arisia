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
	public enum Format {
		case JavaScript
		case TypeScript
		case TypeDeclaration
	}

	private var mScriptFile: 	String
	private var mOutputFormat:	Format

	public var scriptFile: String		{ get { return mScriptFile	}}
	public var outputFormat: Format		{ get { return mOutputFormat	}}


	public init(scriptFile file: String, outputFormat form: Format){
		mScriptFile	= file
		mOutputFormat	= form
	}

	public func outputFileName() -> Result<String, NSError> {
		let ext: String
		switch mOutputFormat {
		case .JavaScript:	ext = ".js"
		case .TypeScript:	ext = ".ts"
		case .TypeDeclaration:	ext = "-if.d.ts"
		}
		return replaceFileName(sourceFile: mScriptFile, extension: ext)
	}

	private func replaceFileName(sourceFile src: String, extension ext: String) -> Result<String, NSError> {
		let nsstr: NSString = src as NSString
		let newname = nsstr.lastPathComponent.replacingOccurrences(of: ".as", with: ext)
		if newname != src {
			return .success(newname)
		} else {
			return .failure(NSError.fileError(message: "Failed to get destination file name from \(src)"))
		}
	}
}

public class CommandLineParser
{
	public typealias Format = Config.Format

	private enum OptionId: Int {
		case Help		= 0
		case Version		= 1
		case Format		= 2
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
		"    --format, -f <lang>   : The output format: \"JavaScript\" (default),\n" +
		"                            \"TypeScript\" or \"TypeDeclaration\"\n" +
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
		var srcfile: String?		= nil
		var format: Format		= .JavaScript
		let stream   			= CNArrayStream(source: args)
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
					case .Format:
						if let form = parseFormat(values: opt.parameters) {
							format = form
						} else {
							return nil
						}
					}
				} else {
					mConsole.error(string: "[Error] Unknown command line option id")
				}
			} else if let param = arg as? CBNormalArgument {
				if srcfile == nil {
					srcfile = param.argument
				} else {
					mConsole.error(string: "[Error] You can not give multiple source files")
					return nil
				}
			} else {
				mConsole.error(string: "[Error] Unknown command line parameter: \(arg)")
				return nil
			}
		}
		if let file = srcfile {
			return Config(scriptFile: file, outputFormat: format)
		} else {
			mConsole.error(string: "[Error] The souce file name is required\n")
			return nil
		}
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
			CBOptionType(optionId: OptionId.Format.rawValue,
				     shortName: "f", longName: "format",
				     parameterNum: 1, parameterType: .stringType,
				     helpInfo: "The format of output file"),
		]
		let config = CBParserConfig(hasSubCommand: false)
		config.setDefaultOptions(optionTypes: opttypes)
		return config
	}

	private func parseFormat(values vals: Array<CBValue>) -> Format? {
		let result: Format?
		switch vals.count {
		case 1:
			if let form = parseFormat(value: vals[0]) {
				result = form
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

	private func parseFormat(value val: CBValue) -> Format? {
		let result: Format?
		switch val {
		case .stringValue(let str):
			switch str {
			case "JavaScript":	result = .JavaScript
			case "TypeScript":	result = .TypeScript
			case "TypeDeclaration":	result = .TypeDeclaration
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
