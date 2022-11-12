/**
 * @file	ALTypeDeclGenerator.swift
 * @brief	Define ALTypeDeclGenerator class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
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
			} else {
				CNLog(logLevel: .error, message: "The property \"\(pname)\" has no type")
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

	public static func generateRecordDeclaration(resource res: KEResource) -> CNTextSection? {
		if let idents = res.identifiersOfStorage() {
			if idents.count > 0 {
				let result = CNTextSection()
				for ident in idents {
					if let strg = res.loadStorage(identifier: ident) {
						let path   = CNValuePath(identifier: nil, elements: [])
						let subtxt = generateRecordDeclaration(storageName: ident, path: path, rootValue: strg.toValue())
						if !subtxt.isEmpty() {
							result.add(text: subtxt)
						}
					}
				}
				return !result.isEmpty() ? result : nil
			}
		}
		return nil
	}

	private static func generateRecordDeclaration(storageName strg: String, path pth: CNValuePath, rootValue val: CNValue) -> CNTextSection {
		let result = CNTextSection()
		switch val {
		case .boolValue(_), .numberValue(_), .stringValue(_), .enumValue(_), .objectValue(_):
			/* ignore scalar value*/
			break
		case .arrayValue(let elms):
			for i in 0..<elms.count {
				let newpath = CNValuePath(path: pth, subPath: [.index(i)])
				let newtxt  = generateRecordDeclaration(storageName: strg, path: newpath, rootValue: elms[i])
				result.add(text: newtxt)
			}
		case .setValue(let elms):
			for i in 0..<elms.count {
				let newpath = CNValuePath(path: pth, subPath: [.index(i)])
				let newtxt  = generateRecordDeclaration(storageName: strg, path: newpath, rootValue: elms[i])
				result.add(text: newtxt)
			}
		case .dictionaryValue(let dict):
			if let fields = getDefaultFields(value: dict) {
				if let subtxt = decodeFields(storageName: strg, path: pth, fields: fields) {
					result.add(text: subtxt)
				}
			} else {
				for (key, elm) in dict {
					let newpath = CNValuePath(path: pth, subPath: [.member(key)])
					let newtxt  = generateRecordDeclaration(storageName: strg, path: newpath, rootValue: elm)
					result.add(text: newtxt)
				}
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown value type", atFunction: #function, inFile: #file)
		}
		return result
	}

	private static func getDefaultFields(value val: Dictionary<String, CNValue>) -> Dictionary<String, CNValue>? {
		if let clsname = CNValue.className(forValue: val) {
			if clsname == "Table" {
				if let fval = val["defaultFields"] {
					switch fval {
					case .dictionaryValue(let dict):
						return dict
					default:
						break
					}
				}
			}
		}
		return nil
	}

	private static func decodeFields(storageName strg: String, path pth: CNValuePath, fields flds: Dictionary<String, CNValue>) -> CNTextSection? {
		let ifname = pathToRecordIF(storageName: strg, path: pth)
		let ifdecl = CNTextSection()
		ifdecl.header = "interface \(ifname) extends RecordIF {"
		ifdecl.footer = "}"

		for (key, val) in flds {
			let txt = CNTextLine(string: "\(key): \(val.valueType.toTypeDeclaration()) ;")
			ifdecl.add(text: txt)
		}

		return ifdecl
	}

	public static func pathToRecordIF(storageName strg: String, path pth: CNValuePath) -> String {
		var result = strg
		for elm in pth.elements {
			result += "_"
			switch elm {
			case .index(let i):
				result += "\(i)"
			case .member(let str):
				result += str
			case .keyAndValue(let key, let val):
				result += key + "_" + val.description
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown element type")
			}
		}
		return result + "_RecordIF"
	}

}


