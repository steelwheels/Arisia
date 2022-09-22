/**
 * @file	ALScriptExecitor,swift
 * @brief	Define ALScriptExecutor class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public class ALScriptExecutor
{
	private var mConfig: ALConfig

	public init(config conf: ALConfig){
		mConfig = conf
	}

	public func execute(context ctxt: KEContext, script scr: CNText, sourceFile file: URL?) -> ALFrame? {
		ctxt.resetErrorCount()
		let retval = ctxt.evaluateScript(script: scr.toStrings().joined(separator: "\n"), sourceFile: file)
		if ctxt.errorCount == 0 && retval.isObject {
			if let rootobj = retval.toObject() as? ALFrame {
				return rootobj
			}
		}
		return nil
	}
}

