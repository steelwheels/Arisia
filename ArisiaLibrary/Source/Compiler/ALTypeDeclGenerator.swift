/**
 * @file	ALTypeDeclGenerator.swift
 * @brief	Define ALTypeDeclGenerator class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALTypeDeclGenerator
{
	private var mConfig: ALConfig

	public init(config conf: ALConfig){
		mConfig = conf
	}

	public func generateTypeDeclaration(frame frm: ALFrame) -> CNTextSection {
		let result = CNTextSection()

		/* Generate declaration for current frame */
		let txt = generateOneTypeDeclaration(frame: frm)
		result.add(text: txt)

		/* Generate declaration for child frames */
		for prop in frm.propertyNames {
			if let child = frm.frameValue(name: prop) {
				let txt = generateTypeDeclaration(frame: child)
				result.add(text: txt)
			}
		}

		return result
	}

	private func generateOneTypeDeclaration(frame frm: ALFrame) -> CNTextSection {
		let ifname = frm.path.interfaceName

		let ifdecl = CNTextSection()
		ifdecl.header = "interface \(ifname) {"
		ifdecl.footer = "}"

		for pname in frm.propertyNames {
			if let vtype = frm.propertyType(propertyName: pname) {
				let decl: String
				switch vtype {
				case .functionType(_, _):
					decl = pname + vtype.toTypeDeclaration() + " ;"
				case .objectType(_):
					let ifname: String
					if let child = frm.frameValue(name: pname) {
						ifname = child.path.interfaceName
					} else {
						CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
						ifname = "<no-if>"
					}
					decl = pname + ": " + ifname + " ;"
				default:
					decl = pname + ": " + vtype.toTypeDeclaration() + " ;"
				}
				ifdecl.add(text: CNTextLine(string: decl))
			}
		}
		return ifdecl
	}

	public static func generateBaseDeclaration(frame frm: ALFrame) -> CNTextSection {
		let ifname = ALFunctionInterface.defaultInterfaceName(frameName: frm.frameName)

		let ifdecl = CNTextSection()
		ifdecl.header = "interface \(ifname) {"
		ifdecl.footer = "}"

		for pname in frm.propertyNames {
			if let vtype = frm.propertyType(propertyName: pname) {
				let decl: String
				switch vtype {
				case .functionType(_, _):
					decl = pname + vtype.toTypeDeclaration() + " ;"
				case .objectType(_):
					let ifname: String
					if let child = frm.frameValue(name: pname) {
						ifname = ALFunctionInterface.defaultInterfaceName(frameName: child.frameName)
					} else {
						CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
						ifname = "<no-if>"
					}
					decl = pname + ": " + ifname + " ;"
				default:
					decl = pname + ": " + vtype.toTypeDeclaration() + " ;"
				}
				ifdecl.add(text: CNTextLine(string: decl))
			}
		}
		return ifdecl
	}
}


