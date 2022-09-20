/**
 * @file	ALScriptConstructor.swift
 * @brief	Define ALScripttConstructorr class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALScriptConstructor
{
	private var mConfig:	ALConfig

	public init(config conf: ALConfig){
		mConfig = conf
	}

	public func construct(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()

		switch insertListnerCallers(frame: frm, instanceName: mConfig.rootFrameName, pathStack: CNStack()) {
		case .success(let txt):
			result.add(text: txt)
		case .failure(let err):
			return .failure(err)
		}

		switch insertInitCallers(frame: frm, instanceName: mConfig.rootFrameName, pathStack: CNStack()) {
		case .success(let txt):
			result.add(text: txt)
		case .failure(let err):
			return .failure(err)
		}
		return .success(result)
	}

	public func insertListnerCallers(frame frm: ALFrameIR, instanceName iname: String, pathStack paths: CNStack<String>) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		paths.push(iname)
		/* Visit children */
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .frame(let child):
					switch insertListnerCallers(frame: child, instanceName: pname, pathStack: paths) {
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
		/* Visit the frame itself */
		switch insertListnerCaller(frame: frm, pathStack: paths) {
		case .success(let txt):
			if !txt.isEmpty() {
				result.add(text: CNTextLine(string: "/* call listner methods to initialize it's property value for frame \(iname) */"))
				result.add(text: txt)
			}
			let _ = paths.pop()
			return .success(result)
		case .failure(let err):
			let _ = paths.pop()
			return .failure(err)
		}
	}

	public func insertListnerCaller(frame frm: ALFrameIR, pathStack paths: CNStack<String>) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .listnerFunction(let lfunc):
					/* Add statement to call the listner */
					let pathstr  = paths.peekAll(doReverseOrder: false).joined(separator: ".")
					let funcname = ALListnerFunctionIR.functionBodyName(name: pname)
					var argstr   = pathstr // callee
					for patharg in lfunc.pathArguments {
						let pathexp = patharg.pathExpression.pathElements.joined(separator: ".")
						argstr += ", " + pathexp
					}
					let line     = CNTextLine(string: "\(pathstr).\(pname) = \(pathstr).\(funcname)(\(argstr)) ;")
					result.add(text: line)
				default:
					break
				}
			}
		}
		return .success(result)
	}

	public func insertInitCallers(frame frm: ALFrameIR, instanceName iname: String, pathStack paths: CNStack<String>) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		paths.push(iname)
		/* Visit children */
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .frame(let child):
					switch insertInitCallers(frame: child, instanceName: pname, pathStack: paths) {
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
		/* Visit the frame itself */
		switch insertInitCaller(frame: frm, pathStack: paths) {
		case .success(let txt):
			if !txt.isEmpty() {
				result.add(text: CNTextLine(string: "/* execute initializer methods for frame \(iname) */"))
				result.add(text: txt)
			}
			let _ = paths.pop()
			return .success(result)
		case .failure(let err):
			let _ = paths.pop()
			return .failure(err)
		}
	}

	public func insertInitCaller(frame frm: ALFrameIR, pathStack paths: CNStack<String>) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .initFunction(_):
					/* Add statement to call the initializer */
					let pathstr  = paths.peekAll(doReverseOrder: false).joined(separator: ".")
					let funcname = ALInitFunctionIR.functionBodyName(name: pname)
					let line     = CNTextLine(string: "\(pathstr).\(pname) = \(pathstr).\(funcname)(\(pathstr)) ;")
					result.add(text: line)
				default:
					break
				}
			}
		}
		return .success(result)
	}
}

