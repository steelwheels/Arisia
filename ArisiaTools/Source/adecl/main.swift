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
	guard let (config, _) = cmdline.parseArguments(arguments: Array(args.dropFirst())) else {
		return
	}
	guard let vm    = JSVirtualMachine() else {
		console.error(string: "[Error] Failed to allocate VM")
		return
	}
	let packdir  = URL(fileURLWithPath: "/bin", isDirectory: true)
	let resource = KEResource(packageDirectory: packdir)

	let ctxt     = KEContext(virtualMachine: vm)
	let lconf    = ALConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
	guard compile(context: ctxt, resource: resource, config: lconf, console: console) else {
		console.error(string: "[Error] Failed to compile")
		return
	}

	let clsnames: Array<String>
	if config.frameNames.isEmpty {
		let allocator = ALFrameAllocator.shared
		clsnames = allocator.classNames
	} else {
		clsnames = config.frameNames
	}
	
	for clsname in clsnames {
		let _ = dump(className: clsname, context: ctxt, resource: resource, console: console)
	}
}

main(arguments: CommandLine.arguments)

