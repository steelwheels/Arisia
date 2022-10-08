/**
 * @file	ALInterface.swift
 * @brief	Define ALFunctionInterface class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import Foundation

public class ALFunctionInterface
{
	public static func defaultInterfaceName(frameName name: String) -> String {
		return name + "IF"
	}

	public static func userInterfaceName(path pth: Array<String>, instanceName iname: String, frameName fname: String) -> String {
		let pathstr = pth.count > 0 ? pth.joined(separator: "_") + "_" : ""
		return defaultInterfaceName(frameName: pathstr + iname + "_" + fname)
	}

}


