/**
 * @file	ALValueIRswift
 * @brief	Define ALValueIR enum
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public indirect enum ALTypeIR
{
	case bool
	case number
	case string
	case frame(String)		// class name
	case array(ALTypeIR)		// type of element
	case dictionary(ALTypeIR)	// type of element
	case enumType(CNEnumType)
	case initFunction
	case eventFunction
	case listnerFunction
	case proceduralFunction

	public func toName() -> String {
		let result: String
		switch self {
		case .bool:			result = "boolean"
		case .number:			result = "number"
		case .string:			result = "string"
		case .frame(let name):		result = name
		case .array(let etype):		result = etype.toName() + "[]"
		case .dictionary(let etype):	result = "[name: string]:" + etype.toName()
		case .enumType(let etype):	result = etype.typeName
		case .initFunction:		result = "init"
		case .eventFunction:		result = "event"
		case .listnerFunction:		result = "listner"
		case .proceduralFunction:	result = "function"
		}
		return result
	}
}

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
}
