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
	private var mLanguageConfig: ALLanguageConfig

	public init(config conf: ALLanguageConfig){
		mLanguageConfig = conf
	}

	public func transpile(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		return transpileFrames(identifier: mLanguageConfig.rootFrameName, frame: frm)
	}

	private func transpileFrames(identifier ident: String, frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		switch transpileOneFrame(instanceName: ident, frame: frm) {
		case .success(let txt):
			result.add(text: txt)
			for prop in frm.propertyNames {
				if let val = frm.value(name: prop) {
					switch val {
					case .frame(let child):
						switch transpileFrames(identifier: prop, frame: child) {
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

	private func transpileOneFrame(instanceName inst: String, frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()

		result.add(text: CNTextLine(string: "/* allocate function for frame: \(frm.className) */"))
		let line = CNTextLine(string: "let \(inst) = _allocateFrameCore(\"\(frm.className)\") ;")
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
				default:
					switch assignProperty(instanceName: inst, propertyName: pname, value: pval) {
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

	private func definePropertyTypes(instanceName inst: String, frame frm: ALFrameIR) -> CNTextSection {
		let result = CNTextSection()
		for prop in frm.properties {
			let pname   = prop.name
			let typestr = prop.type.encode()
			let line    = CNTextLine(string: "\(inst).definePropertyType(\"\(pname)\", \"\(typestr)\") ;")
			result.add(text: line)
		}
		return result
	}

	private func definePropertyNames(instanceName inst: String, frame frm: ALFrameIR) -> CNTextLine {
		var usernames: Array<String> = []
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				usernames.append(pname)
				if let funcname = functionBodyName(name: pname, value: pval) {
					usernames.append(funcname)
				}
			}
		}
		let propnames = usernames.map { "\"" + $0 + "\"" }
		let userdecls = "[" + propnames.joined(separator: ",") + "]"
		let line = CNTextLine(string: "_definePropertyIF(\(inst), \(userdecls)) ;")
		return line
	}

	private func functionBodyName(name nm: String, value val: ALValueIR) -> String? {
		switch val {
		case .initFunction(_):
			return ALInitFunctionIR.functionBodyName(name: nm)
		case .listnerFunction(_):
			return ALListnerFunctionIR.functionBodyName(name: nm)
		default:
			return nil
		}
	}

	private func assignProperty(instanceName inst: String, propertyName pname: String, value pval: ALValueIR) -> Result<String, NSError> {
		switch valueToScript(value: pval) {
		case .success(let valstr):
			let bodyname: String
			if let bname = functionBodyName(name: pname, value: pval) {
				bodyname = bname
			} else {
				bodyname = pname
			}
			return .success("\(inst).\(bodyname) = " + valstr + ";")
		case .failure(let err):
			return .failure(err)
		}
	}

	private func valueToScript(value val: ALValueIR) -> Result<String, NSError> {
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
			switch arrayToScript(value: elms) {
			case .success(let text):
				result = text
			case .failure(let err):
				return .failure(err)
			}
		case .dictionary(let dict):
			switch dictionaryToScript(values: dict) {
			case .success(let text):
				result = text
			case .failure(let err):
				return .failure(err)
			}
		case .enumValue(let etype, let name, _):
			result = "\(etype.typeName).\(name)"
		case .initFunction(let ifunc):
			result = ifunc.toScript()
		case .eventFunction(let efunc):
			result = efunc.toScript()
		case .listnerFunction(let lfunc):
			result = lfunc.toScript()
		case .proceduralFunction(let pfunc):
			result = pfunc.toScript()
		}
		return .success(result)
	}

	private func arrayToScript(value elms: Array<ALValueIR>) -> Result<String, NSError>  {
		var astr: String = "["
		var is1st = true
		for elm in elms {
			switch valueToScript(value: elm) {
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

	private func dictionaryToScript(values dict: Dictionary<String, ALValueIR>) -> Result<String, NSError>  {
		var dstr: String = "{"
		var is1st = true
		let names = dict.keys.sorted()
		for name in names {
			if let val = dict[name] {
				switch valueToScript(value: val) {
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

