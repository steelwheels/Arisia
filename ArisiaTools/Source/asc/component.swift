/**
 * @file	components..swift
 * @brief	Define function for component
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaComponents
import ArisiaLibrary
import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public func defineBuiltinComponents()
{
	let allocator = ALFrameAllocator.shared
	let comps = AMLibraryCompiler.builtinComponentNames
	for comp in comps {
		if let iftype = AMLibraryCompiler.interfaceType(forComponent: comp) {
			allocator.add(className: comp,
				allocator: ALFrameAllocator.Allocator(frameName: comp, allocFuncBody: {
					(_ ctxt: KEContext) -> ALFrame? in return nil
				},
				interfaceType: iftype
			))
		} else {
			CNLog(logLevel: .error, message: "Can not register the allocator" + "for \(comp)", atFunction: #function, inFile: #file)
		}
	}
}
