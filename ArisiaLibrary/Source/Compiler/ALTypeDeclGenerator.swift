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

	public func generateTypeDeclaration(path pth: ALFramePath, frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()

		/* Generate declaration for current frame */
		switch generateOneTypeDeclaration(path: pth, frame: frm) {
		case .success(let txt):
			result.add(text: txt)
		case .failure(let err):
			return .failure(err)
		}

		/* Generate declaration for child frames */
		for prop in frm.properties {
			switch prop.value {
			case .frame(let child):
				let cpath = pth.childPath(childInstanceName: prop.name, childFrameName: child.className)
				switch generateTypeDeclaration(path: cpath, frame: child) {
				case .success(let txt):
					result.add(text: txt)
				case .failure(let err):
					return .failure(err)
				}
			default:
				break // nothing have to do
			}
		}

		return .success(result)
	}

	private func generateOneTypeDeclaration(path pth: ALFramePath, frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		var ptypes: Dictionary<String, CNValueType>
		switch ALTypeDeclGenerator.defaultPropertyTypes(frameName: frm.className) {
		case .success(let typs):
			ptypes = typs
		case .failure(let err):
			return .failure(err)
		}
		for prop in frm.properties {
			ptypes[prop.name] = prop.type
		}
		let ifname = ALFunctionInterface.userInterfaceName(path: pth.path, instanceName: pth.instanceName, frameName: frm.className)
		return .success(ALTypeDeclGenerator.generatePropertyDeclaration(interfaceName: ifname, frameName: frm.className, propertyTypes: ptypes))
	}

	public static func generateBaseDeclaration(frameName fname: String) -> Result<CNTextSection, NSError> {
		/* Collect property types */
		let ptypes: Dictionary<String, CNValueType>
		switch defaultPropertyTypes(frameName: fname) {
		case .success(let p):
			ptypes = p
		case .failure(let err):
			return .failure(err)
		}
		let ifname = ALFunctionInterface.defaultInterfaceName(frameName: fname)
		return .success(generatePropertyDeclaration(interfaceName: ifname, frameName: fname, propertyTypes: ptypes))
	}

	public static func generatePropertyDeclaration(interfaceName ifname: String, frameName fname: String, propertyTypes ptypes: Dictionary<String, CNValueType>) -> CNTextSection {
		let ifdecl = CNTextSection()
		ifdecl.header = "interface \(ifname) {"
		ifdecl.footer = "}"

		for pname in ptypes.keys.sorted() {
			if let vtype = ptypes[pname] {
				let decl: String
				switch vtype {
				case .functionType(_, _):
					decl = pname + vtype.toTypeDeclaration() + " ;"
				case .objectType(let cname):
					let clsname = cname ?? ALDefaultFrame.FrameName
					let ifname  = ALFunctionInterface.defaultInterfaceName(frameName: clsname)
					decl = pname + ": " + ifname + " ;"
				default:
					decl = pname + ": " + vtype.toTypeDeclaration() + " ;"
				}
				ifdecl.add(text: CNTextLine(string: decl))
			}
		}
		return ifdecl
	}

	private static func defaultPropertyTypes(frameName fname: String) -> Result<Dictionary<String, CNValueType>, NSError> {
		guard let allocator = ALFrameAllocator.shared.search(byClassName: fname) else {
			return .failure(NSError.parseError(message: "Unknown class name: \(fname)"))
		}
		var ptypes: Dictionary<String, CNValueType> = [:]
		for (name, type) in allocator.propertyTypes {
			ptypes[name] = type
		}
		return .success(ptypes)
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


