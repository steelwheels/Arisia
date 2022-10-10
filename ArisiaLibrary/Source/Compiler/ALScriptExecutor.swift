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

	public func execute(context ctxt: KEContext, script scr: CNText, sourceFile file: URL?, resource res: KEResource) -> ALFrame? {
		ctxt.resetErrorCount()
		let retval = ctxt.evaluateScript(script: scr.toStrings().joined(separator: "\n"), sourceFile: file)
		if ctxt.errorCount == 0 && retval.isObject {
			if let rootobj = retval.toObject() as? ALFrameCore {
				if let core = rootobj.owner as? ALFrame {
					setup(frame: core, path:[], instanceName: mConfig.rootInstanceName, resource: res)
					return core
				}
			}
		}
		let place: String
		if let u = file { place = "at " + u.path } else { place = "" }
		CNLog(logLevel: .error, message: "Invalid root frame: \(retval) \(place)", atFunction: #function, inFile: #file)
		return nil
	}

	private func setup(frame frm: ALFrame, path pth: Array<String>, instanceName iname: String, resource res: KEResource) {
		/* visit children */
		for pname in frm.propertyNames {
			if let val = frm.value(name: pname) {
				if val.isObject {
					if let child = val.toObject() as? ALFrameCore {
						if let cframe = child.owner as? ALFrame {
							var subpath = pth ; subpath.append(iname)
							setup(frame: cframe, path: subpath, instanceName: pname, resource: res)
						}
					}
				}
			}
		}
		/* setup the frame */
		let newpath = ALFramePath(path: pth, instanceName: iname, frameName: frm.frameName)
		if let err = frm.setup(path: newpath, resource: res) {
			CNLog(logLevel: .error, message: err.toString())
		}
	}
}

