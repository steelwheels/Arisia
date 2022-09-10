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
							result.add(text: txt)
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
		let line = CNTextLine(string: "let \(inst) = _allocateFrameCore(\"\(frm.className)\") ;")
		result.add(text: line)

		let scope = CNTextSection()
		scope.header = "{"
		scope.footer = "}"
		result.add(text: scope)

		/* Define getter/setter for all properties*/
		scope.add(text: definePropertyNames(instanceName: inst, frame: frm))
		/* Assign user declared properties */
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch assignProperty(instanceName: inst, propertyName: pname, value: pval) {
				case .success(let text):
					for line in text.split(separator: "\n") {
						scope.add(text: CNTextLine(string: String(line)))
					}
				case .failure(let err):
					return .failure(err)
				}
			}
		}

		return .success(result)
	}

	private func definePropertyNames(instanceName inst: String, frame frm: ALFrameIR) -> CNTextLine {
		let propnames = frm.propertyNames.map { "\"" + $0 + "\"" }
		let userdecls = "[" + propnames.joined(separator: ",") + "]"
		let line = CNTextLine(string: "_definePropertyIF(\(inst), \(userdecls)) ;")
		return line
	}

	private func assignProperty(instanceName inst: String, propertyName pname: String, value pval: ALValueIR) -> Result<String, NSError> {
		let newpname: String
		switch pval {
		case .listnerFunction(_):
			newpname = listnerFunctionName(name: pname)
		default:
			newpname = pname
		}
		switch valueToScript(value: pval) {
		case .success(let valstr):
			return .success("\(inst).\(newpname) = " + valstr + ";")
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

	private func listnerFunctionName(name nm: String) -> String {
		return "_listner_" + nm
	}
}

