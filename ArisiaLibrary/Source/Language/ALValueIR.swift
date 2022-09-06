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
	case enumValue(CNEnumType, Int)		// type, raw value
	case initFunction(ALInitFunctionIR)
	case eventFunction(ALEventFunctionIR)
	case listnerFunction(ALListnerFunctionIR)
	case proceduralFunction(ALProceduralFunctionIR)
}

/*
public indirect enum ALTypeIR
{




	public static func parse(stream strm: CNTokenStream) -> Result<ALTypeIR, NSError> {
		if let sym = strm.requireSymbol() {
			if sym == "[" {
				return parseDictionary(stream: strm)
			} else {
				return .failure(NSError.parseError(message: "Unexpected symbol \"\(sym)\" for type"))
			}
		} else if let ident = strm.requireIdentifier() {
			var type = parseScalar(string: ident)
			while let atype = parseArray(elementType: type, stream: strm) {
				type = atype
			}
			return .success(type)
		} else {
			return .failure(NSError.parseError(message: "Unexpected declaration for type"))
		}
	}

	private static func parseDictionary(stream strm: CNTokenStream) -> Result<ALTypeIR, NSError> {
		guard let _ = strm.requireIdentifier() else {
			return .failure(NSError.parseError(message: "Key identifier for dictionary type is required"))
		}
		guard strm.requireSymbol(symbol: ":") else {
			return .failure(NSError.parseError(message: "`:` for dictionary type is required"))
		}
		guard let _ = strm.requireIdentifier() else {
			return .failure(NSError.parseError(message: "Value identifier for dictionary type is required"))
		}
		switch parse(stream: strm) {
		case .success(let etype):
			return .success(.dictionary(etype))
		case .failure(let err):
			return .failure(err)
		}
	}

	private static func parseScalar(string str: String) -> ALTypeIR {
		let result: ALTypeIR
		switch str {
		case ALTypeIR.bool.toName():
			result = .bool
		case ALTypeIR.number.toName():
			result = .number
		case ALTypeIR.string.toName():
			result = .string
		case ALTypeIR.initFunction.toName():
			result = .initFunction
		case ALTypeIR.eventFunction.toName():
			result = .eventFunction
		case ALTypeIR.listnerFunction.toName():
			result = .listnerFunction
		case ALTypeIR.proceduralFunction.toName():
			result = .proceduralFunction
		default:
			result = .frame(str)
		}
		return result
	}

	private static func parseArray(elementType etype: ALTypeIR, stream strm: CNTokenStream) -> ALTypeIR? {
		if strm.requireSymbol(symbol: "[") {
			if strm.requireSymbol(symbol: "]") {
				return .array(etype)
			} else {
				let _ = strm.unget()
			}
		}
		return nil
	}
}
*/

