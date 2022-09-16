/**
 * @file	ALValueIRswift
 * @brief	Define ALValueIR enum
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public indirect enum ALType
{
	case bool
	case number
	case string
	case frame(String)		// class name
	case array(ALType)		// type of element
	case dictionary(ALType)	// type of element
	case enumType(CNEnumType)
	case initFunction
	case eventFunction
	case listnerFunction
	case proceduralFunction
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
