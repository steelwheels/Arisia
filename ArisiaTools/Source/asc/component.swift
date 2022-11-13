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
		switch comp {
		case AMButton.ClassName:	ptypes = AMButton.propertyTypes
		case AMBox.ClassName:		ptypes = AMBox.propertyTypes
		case AMCollection.ClassName:	ptypes = AMCollection.propertyTypes
		case AMImage.ClassName:		ptypes = AMImage.propertyTypes
		case AMLabel.ClassName:		ptypes = AMLabel.propertyTypes
		case AMTableData.ClassName:	ptypes = AMTableData.propertyTypes
		default:
			CNLog(logLevel: .error, message: "Unknown component: \(comp)")
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
