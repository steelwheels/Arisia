/**
 * @file	ALFrameIR.swift
 * @brief	Define ALFrameIR class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import Foundation

public class ALFrameIR
{
	public enum Member {
		case bool(Bool)
		case number(NSNumber)
		case string(String)

		case frame(ALFrameIR)
		case array(Array<Member>)
		case dictionary(Dictionary<String, Member>)
		case initFunction(ALInitFunctionIR)
		case eventFunction(ALEventFunctionIR)
		case listnerFunction(ALListnerFunctionIR)
		case procedureFunction(ALProceduralFunctionIR)
	}

	private var mClassName:		String
	private var mInstanceName:	String
	private var mMembers:		Dictionary<String, Member>

	public init(className cname: String, instanceName iname: String) {
		mClassName	= cname
		mInstanceName	= iname
		mMembers	= [:]
	}

	public func set(name nm: String, member val: Member){
		mMembers[nm] = val
	}

	public func member(name nm: String) -> Member? {
		return mMembers[nm]
	}

}
