/**
 * @file	main..swift
 * @brief	Main function for adecl command
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import CoconutData
import JavaScriptCore
import Foundation

func main(arguments args: Array<String>) {
	let console = CNFileConsole()
	let cmdline = CommandLineParser(console: console)
	guard let (config, _) = cmdline.parseArguments(arguments: Array(args.dropFirst())) else {
		return
	}

	/* Define built-in components */
	defineBuiltinComponents()

	/* Collect name of target frames to dump */
	let allocator = ALFrameAllocator.shared
	let clsnames: Array<String>
	if config.frameNames.isEmpty {
		clsnames = allocator.classNames
	} else {
		clsnames = config.frameNames
	}

	/* dump declaration for each class */
	for clsname in clsnames {
		if let alloc = allocator.search(byClassName: clsname) {
			let ptypes = alloc.propertyTypes
			let _ = dump(className: clsname, propertyTypes: ptypes, console: console)
		}
	}
}

private func dump(className cname: String, propertyTypes ptypes: Dictionary<String, CNValueType>, console cons: CNConsole) -> Bool
{
	/* Open the file to write */
	let filename = cname + ".d.ts"
	guard let file = CNFile.open(access: .writer, for: URL(fileURLWithPath: filename)) else {
		cons.error(string: "[Error] Failed to write file: \(filename)\n")
		return false
	}

	let result = CNTextSection()

	/* Generate declaration */
	switch ALTypeDeclGenerator.generateBaseDeclaration(frameName: cname) {
	case .success(let txt):
		result.add(text: txt)
	case .failure(let err):
		cons.error(string: "[Error] Failed to general declaration: \(err.toString())\n")
		return false
	}

	/* Allocator function */
	let ifname = ALFunctionInterface.defaultInterfaceName(frameName: cname)
	let proto = CNTextLine(string: "declare function _alloc_\(cname)(): \(ifname) ;")
	result.add(text: proto)

	file.put(string: result.toStrings().joined(separator: "\n") + "\n")

	/* close the file*/
	file.close()
	return true
}

main(arguments: CommandLine.arguments)

