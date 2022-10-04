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
		return generateTypeDeclaration(path: [], instanceName: mConfig.rootInstanceName, frame: frm)
	}

	private func generateTypeDeclaration(path pth: Array<String>, instanceName iname: String, frame frm: ALFrame) -> CNTextSection {
		let result = CNTextSection()

		/* Generate declaration for current frame */
		let txt = generateOneTypeDeclaration(path: pth, instanceName: iname, frame: frm)
		result.add(text: txt)

		/* Generate declaration for child frames */
		var subpath = pth ; subpath.append(iname)
		for prop in frm.propertyNames.sorted() {
			if let val = frm.value(name: prop) {
				if let core = val.toObject() as? ALFrameCore {
					if let child = core.owner as? ALFrame {
						let txt = generateOneTypeDeclaration(path: subpath, instanceName: prop, frame: child)
						result.add(text: txt)
					}
				}
			}
		}

		return result
	}

	private func generateOneTypeDeclaration(path pth: Array<String>, instanceName iname: String, frame frm: ALFrame) -> CNTextSection {
		let ifname = ALFunctionInterface.userInterfaceName(path: pth, instanceName: iname, frameName: frm.frameName)
		let ifdecl = CNTextSection()
		ifdecl.header = "interface \(ifname) {"
		ifdecl.footer = "}"

		for pname in frm.propertyNames.sorted() {
			if let vtype = frm.propertyType(propertyName: pname) {
				switch vtype {
				case .functionType(_, _):
					let decl = pname + vtype.toTypeDeclaration() + " ;"
					ifdecl.add(text: CNTextLine(string: decl))
				default:
					let decl = pname + " : " + vtype.toTypeDeclaration() + " ;"
					ifdecl.add(text: CNTextLine(string: decl))
				}
			}
		}
		return ifdecl
	}

	public static func generateBaseDeclaration(frame frm: ALFrame, config conf: ALConfig) -> CNTextSection {
		let ifname = ALFunctionInterface.defaultInterfaceName(frameName: frm.frameName)
		let ifdecl = CNTextSection()
		ifdecl.header = "interface \(ifname) {"
		ifdecl.footer = "}"

		for pname in frm.propertyNames.sorted() {
			if let vtype = frm.propertyType(propertyName: pname) {
				switch vtype {
				case .functionType(_, _):
					let decl = pname + vtype.toTypeDeclaration() + " ;"
					ifdecl.add(text: CNTextLine(string: decl))
				default:
					let decl = pname + " : " + vtype.toTypeDeclaration() + " ;"
					ifdecl.add(text: CNTextLine(string: decl))
				}
			}
		}

		return ifdecl
	}
}


