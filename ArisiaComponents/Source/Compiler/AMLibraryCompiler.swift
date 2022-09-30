/**
 * @file	KMLibraryCompiler.swift
 * @brief	Define KMLibraryCompiler class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiControls
import KiwiEngine
import KiwiLibrary
import CoconutData
import JavaScriptCore

public class AMLibraryCompiler
{
	public init() {
	}

	public func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNConsole, config conf: KEConfig) -> Bool {
		defineAllocators(context: ctxt)
		return true
	}

	private func defineAllocators(context ctxt: KEContext) {
		let allocator = ALFrameAllocator.shared

		/* ButtonView */
		allocator.add(className: AMButtonView.ClassName, allocator: {
			(_ ctxt: KEContext) -> ALFrame in
			return AMButtonView(context: ctxt)
		})
		/* RootView */
		allocator.add(className: ALConfig.rootViewFrameName, allocator: {
			(_ ctxt: KEContext) -> ALFrame in
			return AMStackView(context: ctxt)
		})
		/* StackView */
		allocator.add(className: AMStackView.ClassName, allocator: {
			(_ ctxt: KEContext) -> ALFrame in
			return AMStackView(context: ctxt)
		})
	}
}

