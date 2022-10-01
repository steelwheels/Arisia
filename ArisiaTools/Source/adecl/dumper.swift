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

public func dump(className name: String, context ctxt: KEContext, resource res: KEResource, console cons: CNConsole) -> Bool
{
	let allocator = ALFrameAllocator.shared
	guard let alloc = allocator.search(byClassName: name) else {
		cons.error(string: "[Error] Can not find class: \(name)\n")
		return false
	}
	guard let frame = alloc.allocFuncBody(ctxt) else {
		cons.error(string: "[Error] Failed to allocate frame: \(name)\n")
		return false
	}
	if let err = frame.setup(resource: res) {
		cons.error(string: err.toString() + "\n")
		return false
	}

	/* Open the file to write */
	let filename = name + ".d.ts"
	guard let file = CNFile.open(access: .writer, for: URL(fileURLWithPath: filename)) else {
		cons.error(string: "[Error] Failed to write file: \(filename)\n")
		return false
	}

	let intfdecl = CNTextSection()
	intfdecl.header = "interface \(name)IF {"
	intfdecl.footer = "}"

	for pname in frame.propertyNames {
		if let type = frame.propertyType(propertyName: pname) {
			switch type {
			case .functionType(_, _):
				let decl = pname + type.toTypeDeclaration() + " ;"
				intfdecl.add(text: CNTextLine(string: decl))
			default:
				let decl = pname + " : " + type.toTypeDeclaration() + " ;"
				intfdecl.add(text: CNTextLine(string: decl))
			}
		} else {
			cons.error(string: "[Error] No property type for \(pname)\n")
			return false
		}
	}

	/* Define constructor */
	let allocname = alloc.allocFuncName()
	let constdecl = CNTextLine(string: "declare function \(allocname)(): \(name)IF ;")

	let text = CNTextSection()
	text.add(text: intfdecl)
	text.add(text: constdecl)
	file.put(string: text.toStrings().joined(separator: "\n") + "\n")

	/* close the file*/
	file.close()
	return true
}

