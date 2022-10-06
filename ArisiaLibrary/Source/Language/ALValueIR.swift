/**
 * @file	ALValueIRswift
 * @brief	Define ALValueIR enum
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public enum ALValueIR
{
	case bool(Bool)
	case number(NSNumber)
	case string(String)
	case frame(ALFrameIR)
	case array(Array<ALValueIR>)
	case dictionary(Dictionary<String, ALValueIR>)
	case enumValue(CNEnumType, String, Int)		// type, member, raw value
	case initFunction(ALInitFunctionIR)
	case eventFunction(ALEventFunctionIR)
	case listnerFunction(ALListnerFunctionIR)
	case proceduralFunction(ALProceduralFunctionIR)

	public func toType() -> CNValueType {
		let result: CNValueType
		switch self {
		case .bool(_):
			result = .boolType
		case .number(_):
			result = .numberType
		case .string(_):
			result = .stringType
		case .frame(let frm):
			result = .objectType(frm.className)
		case .array(let arr):
			if arr.count > 0 {
				result = .arrayType(arr[0].toType())
			} else {
				result = .arrayType(.anyType)
			}
		case .dictionary(let dict):
			if dict.count > 0 {
				let elms = Array(dict.values)
				result = .dictionaryType(elms[0].toType())
			} else {
				result = .dictionaryType(.anyType)
			}
		case .enumValue(let etype, _, _):
			result = .enumType(etype)
		case .initFunction(let ifunc):
			result = ifunc.toType()
		case .eventFunction(let efunc):
			result = efunc.toType()
		case .listnerFunction(let lfunc):
			result = lfunc.toType()
		case .proceduralFunction(let pfunc):
			result = pfunc.toType()
		}
		return result
	}
}
