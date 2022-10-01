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

open class AMLibraryCompiler: ALLibraryCompiler
{
	open override func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		/* This allocation must be done before compile in suprt class */
		defineAllocators(context: ctxt)
		return super.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf)
	}

	private func defineAllocators(context ctxt: KEContext) {
		let allocator = ALFrameAllocator.shared

		/* ButtonView */
		allocator.add(className: AMButtonView.ClassName,
			      allocator: ALFrameAllocator.Allocator(frameName: AMButtonView.ClassName, allocFuncBody: {
			(_ ctxt: KEContext) -> ALFrame? in return AMButtonView(context: ctxt)
		}))

		/* RootView */
		allocator.add(className: ALConfig.rootViewFrameName,
			      allocator: ALFrameAllocator.Allocator(frameName: ALConfig.rootViewFrameName, allocFuncBody: {
			(_ ctxt: KEContext) -> ALFrame? in return AMStackView(context: ctxt)
		}))

		/* StackView */
		allocator.add(className: AMStackView.ClassName,
			      allocator: ALFrameAllocator.Allocator(frameName: AMStackView.ClassName, allocFuncBody: {
			(_ ctxt: KEContext) -> ALFrame? in return AMStackView(context: ctxt)
		}))
	}
}

