/**
 * @file	dumper..swift
 * @brief	Define dump function
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiEngine
import CoconutData
import Foundation

public func dump(className cname: String, context ctxt: KEContext, resource res: KEResource, console cons: CNConsole) -> Bool
{
	let allocator = ALFrameAllocator.shared
	guard let alloc = allocator.search(byClassName: cname) else {
		cons.error(string: "[Error] Can not find class: \(cname)\n")
		return false
	}
	guard let frame = alloc.allocFuncBody(ctxt) else {
		cons.error(string: "[Error] Failed to allocate frame: \(cname)\n")
		return false
	}
	if let err = frame.setup(resource: res) {
		cons.error(string: err.toString() + "\n")
		return false
	}

	/* Open the file to write */
	let filename = cname + ".d.ts"
	guard let file = CNFile.open(access: .writer, for: URL(fileURLWithPath: filename)) else {
		cons.error(string: "[Error] Failed to write file: \(filename)\n")
		return false
	}

	let result = CNTextSection()

	/* Generate declaration */
	let config = ALConfig(applicationType: .terminal, doStrict: true, logLevel: .defaultLevel)
	let decl   = ALTypeDeclGenerator.generateBaseDeclaration(frame: frame, config: config)
	result.add(text: decl)

	/* Allocator function */
	let proto = CNTextLine(string: "declare function _alloc_\(frame.frameName)(): \(frame.frameName)IF ;")
	result.add(text: proto)

	file.put(string: result.toStrings().joined(separator: "\n") + "\n")
	/* close the file*/
	file.close()
	return true
}

