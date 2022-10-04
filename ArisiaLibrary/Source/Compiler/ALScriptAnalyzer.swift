/**
 * @file	ALScriptAnalyzer.swift
 * @brief	Define ALScriptAnalyzer class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALScriptAnalyzer: ALScriptLinkerBase
{
	public override init(config conf: ALConfig){
		super.init(config: conf)
	}
	
	public func anayze(frame frm: ALFrameIR) -> NSError? {
		let pstack: CNStack<String> = CNStack()
		return decideParameterTypes(identifier: self.config.rootInstanceName, frame: frm, pathStack: pstack, rootFrame: frm)
	}

	private func decideParameterTypes(identifier ident: String, frame frm: ALFrameIR, pathStack pstack: CNStack<String>, rootFrame root: ALFrameIR) -> NSError? {
		/* updata path stack*/
		pstack.push(ident)
		defer { let _ = pstack.pop() }

		for pname in frm.propertyNames {
			if let pval = frm.value(name: pname) {
				switch pval {
				case .frame(let child):
					/* Visit child frame */
					if let err = decideParameterTypes(identifier: pname, frame: child, pathStack: pstack, rootFrame: root) {
						return err
					}
				case .listnerFunction(let lfunc):
					if let err = decideListnerParameterTypes(listnerName: pname, listnerFunction: lfunc, pathStack: pstack, rootFrame: root) {
						return err
					}
				default:
					break // do nothing
				}
			}
		}
		return nil
	}

	private func decideListnerParameterTypes(listnerName lname: String, listnerFunction lfunc: ALListnerFunctionIR, pathStack pstack: CNStack<String>, rootFrame root: ALFrameIR) -> NSError? {
		for path in lfunc.pathArguments {
			switch pathToFullPath(pathExpression: path.pathExpression, pathStack: pstack, rootFrame: root) {
			case .success(let pathexp):
				switch pointedFrame(by: pathexp, rootFrame: root) {
				case .success(let owner):
					if let prop = owner.frame.property(name: owner.propertyName) {
						/* Set type */
						path.type = prop.type
					} else {
						let pathstr = pathexp.description()
						return NSError.parseError(message: "No object at \(pathstr)")
					}
				case .failure(let err):
					return err
				}
			case .failure(let err):
				return err
			}
		}
		return nil // no error
	}
}

