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
}
