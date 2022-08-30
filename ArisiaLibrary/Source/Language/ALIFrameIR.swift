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
		case frame(ALFrameIR)
	}

	private var mMembers:	Dictionary<String, Member>

	public init() {
		mMembers = [:]
	}
}
