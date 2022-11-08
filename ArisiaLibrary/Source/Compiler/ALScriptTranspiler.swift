/**
 * @file	ALScriptTranspoler.swift
 * @brief	Define ALScriptTranspiler class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALScriptTranspiler
{
	private var mConfig: ALConfig

	public init(config conf: ALConfig){
		mConfig = conf
	}

	public func transpile(frame frm: ALFrameIR, language lang: ALLanguage) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()

		/* Allocate hierarchical frame objects */
		switch transpileFrames(path: [], identifier: mConfig.rootInstanceName, frame: frm, language: lang) {
		case .success(let txt):
			result.add(text: txt)
		case .failure(let err):
			return .failure(err)
		}

		/* Allocate listner functions */
		switch transpileListnerFunctions(path: [], identifier: mConfig.rootInstanceName, frame: frm, language: lang) {
		case .success(let txt):
			if txt.contentCount > 0 {
				result.add(text: CNTextLine(string: "/* Define listner functions */"))
				result.add(text: txt)
			}
		case .failure(let err):
			return .failure(err)
		}

		return .success(result)
	}

	private func transpileListnerFunctions(path pth: Array<String>, identifier ident: String, frame frm: ALFrameIR, language lang: ALLanguage) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .frame(let child):
					var subpath = pth ; subpath.append(ident)
					switch transpileListnerFunctions(path: subpath, identifier: pname, frame: child, language: lang) {
					case .success(let txt):
						result.add(text: txt)
					case .failure(let err):
						return .failure(err)
					}
				case .listnerFunction(_):
					switch valueToScript(value: pval, language: lang) {
					case .success(let str):
						var subpath = pth ; subpath.append(ident)
						let funcname = ALListnerFunctionIR.makeFullPathFuncName(path: subpath, propertyName: pname)
						result.add(text: CNTextLine(string: "let \(funcname) = \(str) ;"))
					case .failure(let err):
						return .failure(err)
					}
				default:
					break
				}
			}
		}
		return .success(result)
	}

	private func transpileFrames(path pth: Array<String>, identifier ident: String, frame frm: ALFrameIR, language lang: ALLanguage) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		switch transpileOneFrame(path: pth, instanceName: ident, frame: frm, language: lang) {
		case .success(let txt):
			result.add(text: txt)
			for prop in frm.propertyNames {
				if let val = frm.value(name: prop) {
					switch val {
					case .frame(let child):
						var subpath = pth ; subpath.append(ident)
						switch transpileFrames(path: subpath, identifier: prop, frame: child, language: lang) {
						case .success(let txt):
							let scope = CNTextSection()
							scope.header = "{" ; scope.footer = "}"
							scope.add(text: txt)
							/* assignment to parent */
							let line = CNTextLine(string: "\(ident).\(prop) = \(prop) ;")
							scope.add(text: line)
							/* insert declaration to parent */
							result.add(text: scope)
						case .failure(let err):
							return .failure(err)
						}
					default:
						break
					}
				}
			}
		case .failure(let err):
			return .failure(err)
		}
		return .success(result)
	}

	private func transpileOneFrame(path pth: Array<String>, instanceName inst: String, frame frm: ALFrameIR, language lang: ALLanguage) -> Result<CNTextSection, NSError> {
		guard let allocator = ALFrameAllocator.shared.search(byClassName: frm.className) else {
			return .failure(NSError.parseError(message: "Unknown class name: \(frm.className)"))
		}

		let result = CNTextSection()
		result.add(text: CNTextLine(string: "/* allocate function for frame: \(frm.className) */"))
		let funcname = allocator.allocFunctionName()
		let asname: String
		switch lang {
		case .ArisiaScript, .TypeScript:
			let ifname   = ALFunctionInterface.userInterfaceName(path: pth, instanceName: inst, frameName: frm.className)
			asname = "as \(ifname)"
		case .JavaScript:
			asname = ""
		}
		let line = CNTextLine(string: "let \(inst) = \(funcname)() \(asname) ;")
		result.add(text: line)

		/* Define type for all properties*/
		let dttxt = definePropertyTypes(instanceName: inst, frame: frm)
		if !dttxt.isEmpty() {
			result.add(text: CNTextLine(string: "/* define type for all properties */"))
			result.add(text: dttxt)
		}

		/* Define getter/setter for all properties */
		let gstxt = definePropertyNames(instanceName: inst, frame: frm)
		if !gstxt.isEmpty() {
			result.add(text: CNTextLine(string: "/* define getter/setter for all properties */"))
			result.add(text: gstxt)
		}

		/* Assign user declared properties */
		let udtxt = CNTextSection()
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .frame(_):
					break
				case .listnerFunction(_):
					/* Already transpiled in transpileListnerFunctions */
					break
				default:
					switch assignProperty(instanceName: inst, propertyName: pname, value: pval, language: lang) {
					case .success(let text):
						for line in text.split(separator: "\n") {
							udtxt.add(text: CNTextLine(string: String(line)))
						}
					case .failure(let err):
						return .failure(err)
					}
				}
			}
		}
		if !udtxt.isEmpty() {
			result.add(text: CNTextLine(string: "/* assign user declared properties */"))
			result.add(text: udtxt)
		}

		return .success(result)
	}


	/*
	 * Call "definePropertyType" methods for each properties in the frame.
	 */
	private func definePropertyTypes(instanceName inst: String, frame frm: ALFrameIR) -> CNTextSection {
		let result = CNTextSection()
		for prop in frm.properties {
			let ptype: CNValueType
			switch prop.value {
			case .listnerFunction(let lfunc):
				/* Use return type instead of the listner function itself */
				ptype = lfunc.returnType
			default:
				ptype = prop.type
			}
			let typestr = CNValueType.encode(valueType: ptype)
			let line    = CNTextLine(string: "\(inst).definePropertyType(\"\(prop.name)\", \"\(typestr)\") ;")
			result.add(text: line)
		}
		return result
	}

	private func definePropertyNames(instanceName inst: String, frame frm: ALFrameIR) -> CNTextLine {
		var usernames: Array<String> = []
		for pname in frm.propertyNames {
			usernames.append(pname)
		}
		let propnames = usernames.map { "\"" + $0 + "\"" }
		let userdecls = "[" + propnames.joined(separator: ",") + "]"
		let line = CNTextLine(string: "_definePropertyIF(\(inst), \(userdecls)) ;")
		return line
	}

	private func assignProperty(instanceName inst: String, propertyName pname: String, value pval: ALValueIR, language lang: ALLanguage) -> Result<String, NSError> {
		switch valueToScript(value: pval, language: lang) {
		case .success(let valstr):
			return .success("\(inst).\(pname) = " + valstr + ";")
		case .failure(let err):
			return .failure(err)
		}
	}

	private func valueToScript(value val: ALValueIR, language lang: ALLanguage) -> Result<String, NSError> {
		let result: String
		switch val {
		case .bool(let bval):
			result = "\(bval)"
		case .number(let nval):
			result = nval.stringValue
		case .string(let sval):
			result = "\"" + sval + "\""
		case .frame(_):
			return .failure(transpileError(message: "Frame can not be operate as a value"))
		case .array(let elms):
			switch arrayToScript(value: elms, language: lang) {
			case .success(let text):
				result = text
			case .failure(let err):
				return .failure(err)
			}
		case .dictionary(let dict):
			switch dictionaryToScript(values: dict, language: lang) {
			case .success(let text):
				result = text
			case .failure(let err):
				return .failure(err)
			}
		case .enumValue(let etype, let name, _):
			result = "\(etype.typeName).\(name)"
		case .initFunction(let ifunc):
			result = ifunc.toScript(language: lang)
		case .eventFunction(let efunc):
			result = efunc.toScript(language: lang)
		case .listnerFunction(let lfunc):
			result = lfunc.toScript(language: lang)
		case .proceduralFunction(let pfunc):
			result = pfunc.toScript(language: lang)
		case .invokedFunction(let ifunc):
			result = ifunc.toScript(language: lang)
		}
		return .success(result)
	}

	private func arrayToScript(value elms: Array<ALValueIR>, language lang: ALLanguage) -> Result<String, NSError>  {
		var astr: String = "["
		var is1st = true
		for elm in elms {
			switch valueToScript(value: elm, language: lang) {
			case .success(let elmstr):
				if is1st {
					is1st = false
				} else {
					astr += ", "
				}
				astr += elmstr
			case .failure(let err):
				return .failure(err)
			}
		}
		astr += "]"
		return .success(astr)
	}

	private func dictionaryToScript(values dict: Dictionary<String, ALValueIR>, language lang: ALLanguage) -> Result<String, NSError>  {
		var dstr: String = "{"
		var is1st = true
		let names = dict.keys.sorted()
		for name in names {
			if let val = dict[name] {
				switch valueToScript(value: val, language: lang) {
				case .success(let valstr):
					if is1st {
						is1st = false
					} else {
						dstr += ", "
					}
					let elmstr = name + ":" + valstr
					dstr += elmstr
				case .failure(let err):
					return .failure(err)
				}
			}
		}
		dstr += "}"
		return .success(dstr)
	}

	private func transpileError(message msg: String) -> NSError {
		return NSError.parseError(message: msg)
	}
}

