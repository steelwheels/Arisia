/**
 * @file	ALFrameTable.swift
 * @brief	Define ALFtameTable class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

public class ALFrameTable
{
	private var mFrameTable: Dictionary<String, ALFrameIR>

	public init(){
		mFrameTable = [:]
	}

	public func search(byName name: String) -> ALFrameIR? {
		return mFrameTable[name]
	}
}

