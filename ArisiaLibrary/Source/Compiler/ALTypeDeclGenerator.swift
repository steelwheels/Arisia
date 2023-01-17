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

		var iftype: CNInterfaceType
		switch ALTypeDeclGenerator.defaultInterfaceType(frameName: frm.className) {
		case .success(let typ):
			iftype = typ
		case .failure(let err):
			return .failure(err)
		}

		var ptypes: Dictionary<String, CNValueType> = [:]
		for prop in frm.properties {
			if iftype.types[prop.name] == nil {
				ptypes[prop.name] = prop.type
			}
		}

		for (key, type) in ALTypeDeclGenerator.additionalPropertyTypes(path: pth, frame: frm) {
			ptypes[key] = type
		}

		let ifname = ALFunctionInterface.userInterfaceName(path: pth.path, instanceName: pth.instanceName, frameName: frm.className)
		let newif = CNInterfaceType(name: ifname, base: iftype, types: ptypes)
		return .success(generatePropertyDeclaration(path: pth, interfaceType: newif, frame: frm))
	}

	public func generatePropertyDeclaration(path pth: ALFramePath, interfaceType iftype: CNInterfaceType, frame frm: ALFrameIR) -> CNTextSection {
		let basename: String
		if let base = iftype.base {
			basename = base.name
		} else {
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			basename = ALFunctionInterface.FrameCoreInterface
		}
		let ifdecl = CNTextSection()
		ifdecl.header = "interface \(iftype.name) extends \(basename) {"
		ifdecl.footer = "}"

		let ptypes = iftype.types
		for pname in ptypes.keys.sorted() {
			if let vtype = ptypes[pname] {
				let decl: String
				switch vtype {
				case .functionType(_, _):
					if let lfunc = getListnerFunction(frame: frm, propertyName: pname) {
						/* return type of listner function */
						decl = pname + ": " + lfunc.returnType.toTypeDeclaration() + " ;"
					} else {
						/* normal function */
						decl = pname + vtype.toTypeDeclaration() + " ;"
					}
				case .objectType(let cname):
					let clsname = cname ?? ALDefaultFrame.FrameName
					let cpath = pth.childPath(childInstanceName: pname, childFrameName: clsname)
					let ifname  = ALFunctionInterface.userInterfaceName(path: cpath.path, instanceName: cpath.instanceName, frameName: clsname)
					decl = pname + ": " + ifname + " ;"
				default:
					decl = pname + ": " + vtype.toTypeDeclaration() + " ;"
				}
				ifdecl.add(text: CNTextLine(string: decl))
			}
		}
		return ifdecl
	}

	private func getListnerFunction(frame frm: ALFrameIR, propertyName pname: String) -> ALListnerFunctionIR? {
		if let prop = frm.property(name: pname) {
			switch prop.value {
			case .listnerFunction(let lfunc):
				return lfunc
			default:
				break
			}
		}
		return nil
	}

	public static func generatePropertyDeclaration(interfaceType iftype: CNInterfaceType) -> CNTextSection {
		let ifdecl = CNTextSection()
		let basename: String
		if let base = iftype.base {
			basename = base.name
		} else {
			basename = ALFunctionInterface.FrameCoreInterface
		}
		ifdecl.header = "interface \(iftype.name) extends \(basename) {"
		ifdecl.footer = "}"

		let ptypes = iftype.types
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

	public static func generateBaseDeclaration(frameName fname: String) -> Result<CNTextSection, NSError> {
		/* Collect property types */
		switch defaultInterfaceType(frameName: fname) {
		case .success(let iftype):
			return .success(generatePropertyDeclaration(interfaceType: iftype))
		case .failure(let err):
			return .failure(err)
		}
	}

	private static func defaultInterfaceType(frameName fname: String) -> Result<CNInterfaceType, NSError> {
		guard let allocator = ALFrameAllocator.shared.search(byClassName: fname) else {
			return .failure(NSError.parseError(message: "Unknown class name: \(fname)"))
		}
		let ifname = ALFunctionInterface.defaultInterfaceName(frameName: fname)
		if let iftype = CNInterfaceTable.currentInterfaceTable().search(byTypeName: ifname) {
			return .success(iftype)
		} else {
			let iftype = allocator.interfaceType
			CNInterfaceTable.currentInterfaceTable().add(interfaceType: iftype)
			return .success(iftype)
		}
	}

	private static func additionalPropertyTypes(path pth: ALFramePath, frame frm: ALFrameIR) -> Dictionary<String, CNValueType> {
		var ptypes: Dictionary<String, CNValueType> = [:]
		if let storageval = frm.value(name: "storage"), let pathval = frm.value(name: "path") {
			if let storage = storageval.toString(), let path = pathval.toString() {
				let recifname = pathToRecordIF(storageName: storage, pathString: path)
				let recif: CNValueType = .interfaceType(CNInterfaceType(name: recifname, base: nil, types: [:]))
				ptypes["record"]    = .functionType(recif, [.numberType])
				ptypes["newRecord"] = .functionType(recif, [])
			}
		}
		return ptypes
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
				for key in dict.keys.sorted() {
					if let elm = dict[key] {
						let newpath = CNValuePath(path: pth, subPath: [.member(key)])
						let newtxt  = generateRecordDeclaration(storageName: strg, path: newpath, rootValue: elm)
						result.add(text: newtxt)
					}
				}
			}
		case .interfaceValue(let ifval):
			let rootval: CNValue = .dictionaryValue(ifval.values)
			let newtxt = generateRecordDeclaration(storageName: strg, path: pth, rootValue: rootval)
			result.add(text: newtxt)
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

		for key in flds.keys.sorted() {
			if let val = flds[key] {
				let txt: CNTextLine
				switch val.valueType {
				case .functionType(_, _):
					txt = CNTextLine(string: "\(key)\(val.valueType.toTypeDeclaration()) ;")
				default:
					txt = CNTextLine(string: "\(key): \(val.valueType.toTypeDeclaration()) ;")
				}
				ifdecl.add(text: txt)
			}
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

	public static func pathToRecordIF(storageName strg: String, pathString path: String) -> String {
		let newpath = path.replacingOccurrences(of: ".", with: "_")
		return strg + "_" + newpath + "_RecordIF"
	}

}


