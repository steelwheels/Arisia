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
	private var mLanguageConfig:	ALLanguageConfig

	public init(config conf: ALLanguageConfig){
		mLanguageConfig = conf
	}

	public func construct(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let paths: CNStack<String> = CNStack()
		return construct(frame: frm, instanceName: mLanguageConfig.rootFrameName, pathStack: paths)
	}

	public func construct(frame frm: ALFrameIR, instanceName iname: String, pathStack paths: CNStack<String>) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		paths.push(iname)
		/* Visit children */
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .frame(let child):
					switch construct(frame: child, instanceName: pname, pathStack: paths) {
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
		switch insertInitializer(frame: frm, pathStack: paths) {
		case .success(let txt):
			result.add(text: txt)
			let _ = paths.pop()
			return .success(result)
		case .failure(let err):
			let _ = paths.pop()
			return .failure(err)
		}
	}

	public func insertInitializer(frame frm: ALFrameIR, pathStack paths: CNStack<String>) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .initFunction(_):
					/* Add statement to call the initializer */
					let pathstr  = paths.peekAll(doReverceOrder: false).joined(separator: ".")
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

