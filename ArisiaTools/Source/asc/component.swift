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
		let ptypes: Dictionary<String, CNValueType>
		if let t = AMLibraryCompiler.propertyTypes(forComponent: comp) {
			ptypes = t
		} else {
			ptypes = [:]
		}
		allocator.add(className: comp,
			allocator: ALFrameAllocator.Allocator(frameName: comp, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return nil
			},
			propertyTypes: ptypes
		))
	}
}
