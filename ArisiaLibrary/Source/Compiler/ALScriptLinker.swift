/**
 * @file	ALScriptLinker.swift
 * @brief	Define ALScriptLinker class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALScriptLinker
{
	private var mLanguageConfig:	ALLanguageConfig

	private struct OwnerFrame {
		public var frame:		ALFrameIR
		public var pathString:		String
		public var propertyName:	String
		public init(frame f: ALFrameIR, pathString p: String, propertyName name: String) {
			frame		= f
			pathString	= p
			propertyName	= name
		}
	}

	public init(config conf: ALLanguageConfig){
		mLanguageConfig = conf
	}

	public func link(frame frm: ALFrameIR) -> Result<CNTextSection, NSError> {
		let pstack: CNStack<String> = CNStack()
		return linkFrames(identifier: mLanguageConfig.rootFrameName, frame: frm, pathStack: pstack, rootFrame: frm)
	}

	private func linkFrames(identifier ident: String, frame frm: ALFrameIR, pathStack pstack: CNStack<String>, rootFrame root: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		/* updata path stack*/
		pstack.push(ident)
		defer { let _ = pstack.pop() }

		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .frame(let child):
					/* Visit child frame */
					switch linkFrames(identifier: pname, frame: child, pathStack: pstack, rootFrame: root) {
					case .success(let txt):
						result.add(text: txt)
					case .failure(let err):
						return .failure(err)
					}
				case .listnerFunction(let lfunc):
					switch linkListnerFunction(listnerName: pname, listnerFunction: lfunc, pathStack: pstack, rootFrame: root) {
					case .success(let txt):
						result.add(text: txt)
					case .failure(let err):
						return .failure(err)
					}
				default:
					break // do nothing
				}
			}
		}
		return .success(result)
	}

	private func linkListnerFunction(listnerName lname: String, listnerFunction lfunc: ALListnerFunctionIR, pathStack pstack: CNStack<String>, rootFrame root: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()

		/* make absolute path from root frame */
		var newpath: Array<ALListnerFunctionIR.PathArgument> = []
		for path in lfunc.pathArguments {
			switch pathToFullPath(pathExpression: path.pathExpression, pathStack: pstack, rootFrame: root) {
			case .success(let pathexp):
				let newarg = ALListnerFunctionIR.PathArgument(name: path.name, pathExpression: pathexp)
				newpath.append(newarg)
			case .failure(let err):
				return .failure(err)
			}
		}
		for i in 0..<newpath.count {
			switch linkListnerFunction(listnerName: lname, pathIndex: i, pathExpressions: newpath, pathStack: pstack, rootFrame: root) {
			case .success(let txt):
				result.add(text: txt)
			case .failure(let err):
				return .failure(err)
			}
		}
		return .success(result)
	}

	private func linkListnerFunction(listnerName lname: String, pathIndex pidx: Int, pathExpressions pargs: Array<ALListnerFunctionIR.PathArgument>, pathStack pstack: CNStack<String>, rootFrame root: ALFrameIR) -> Result<CNTextSection, NSError> {
		switch pointedFrame(by: pargs[pidx].pathExpression, rootFrame: root) {
		case .success(let owner):
			let curpath  = pstack.peekAll(doReverceOrder: false).joined(separator: ".")
			let funcname = ALListnerFunctionIR.functionBodyName(name: lname)
			let funcdecl = CNTextSection()
			funcdecl.header = "\(owner.pathString).addObserver(\"\(owner.propertyName)\", func(){"
			funcdecl.footer = "}) ;"
			let line0 = CNTextLine(string: "let self = \(curpath) ;")
			funcdecl.add(text: line0)
			for parg in pargs {
				let line1 = CNTextLine(string: "let \(parg.name) = \(parg.pathExpression.pathElements.joined(separator: ".")) ;")
				funcdecl.add(text: line1)
			}
			let argstr = pargs.map { $0.name }
			let line = CNTextLine(string: "\(curpath).\(lname) = \(curpath).\(funcname)(self, \(argstr.joined(separator: ","))) ;")
			funcdecl.add(text: line)
			return .success(funcdecl)
		case .failure(let err):
			return .failure(err)
		}
	}

	private func pathToFullPath(pathExpression pexp: ALPathExpressionIR, pathStack pstack: CNStack<String>, rootFrame root: ALFrameIR) -> Result<ALPathExpressionIR, NSError> {
		let elements = pexp.pathElements
		guard elements.count >= 2 else {
			return .failure(linkError(message: "Too short path expression"))
		}
		switch elements[0] {
		case mLanguageConfig.rootFrameName:
			return .success(pexp)
		case "self":
			/* make absolute expression */
			var newelms: Array<String> = pstack.peekAll(doReverceOrder: false)
			for i in 1..<elements.count {
				newelms.append(elements[i])
			}
			return .success(ALPathExpressionIR(elements: newelms))
		default:
			return .failure(linkError(message: "Path expression must be started by " +
			  "\"\(mLanguageConfig.rootFrameName)\" or \"self\" but \"\(elements[0])\" is given"))
		}
	}

	private func pointedFrame(by pexp: ALPathExpressionIR, rootFrame root: ALFrameIR) -> Result<OwnerFrame, NSError> {
		let elements = pexp.pathElements
		guard elements.count >= 2 else {
			return .failure(linkError(message: "Too short path expression"))
		}
		var owner: ALFrameIR = root
		var curpath: String   = mLanguageConfig.rootFrameName
		for i in 1..<elements.count - 1 {
			curpath += "." + elements[i]
			if let child = owner.value(name: elements[i]) {
				switch child {
				case .frame(let child):
					owner = child
				default:
					return .failure(linkError(message: "Path expression does not point the frame: \(curpath)"))
				}
			} else {
				return .failure(linkError(message: "Invalid path expression: \(curpath)"))
			}
		}
		return .success(OwnerFrame(frame: owner, pathString: curpath, propertyName: elements[elements.count - 1]))
	}

	private func linkError(message msg: String) -> NSError {
		return NSError.parseError(message: msg)
	}
}

/*






	private func linkListnerFunction(identifier ident: String, frame frm: ALFrameIR, listnerName lname: String, listnerFunction lfunc: ALListnerFunctionIR, pathStack pstack: CNStack<String>, rootFrame root: ALFrameIR) -> Result<CNTextSection, NSError> {
		let result = CNTextSection()
		for path in lfunc.pathArguments {
			case .success(let pathexp):

			case .failure(let err):
				return .failure(err)
			}
		}
		return .success(result)
	}






*/
