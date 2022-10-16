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
	private var mViewController: AMComponentViewController?

	public init(viewController vcont: AMComponentViewController?) {
		mViewController = vcont
	}

	open override func compile(context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		/* This allocation must be done before compile in suprt class */
		defineAllocators(context: ctxt)

		guard super.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) else {
			return false
		}

		/* Define functions for built-in components */
		if let vcont = mViewController {
			defineComponentFuntion(context: ctxt, viewController: vcont, resource: res)
		}
		return true
	}

	private func defineAllocators(context ctxt: KEContext) {
		let allocator = ALFrameAllocator.shared

		/* Button */
		allocator.add(className: AMButton.ClassName,
			      allocator: ALFrameAllocator.Allocator(frameName: AMButton.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMButton(context: ctxt)
		}))

		/* Box */
		allocator.add(className: AMBox.ClassName,
			      allocator: ALFrameAllocator.Allocator(frameName: AMBox.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMBox(context: ctxt)
		}))

		/* Image */
		allocator.add(className: AMImage.ClassName,
			      allocator: ALFrameAllocator.Allocator(frameName: AMImage.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMImage(context: ctxt)
		}))
		
		/* TableData */
		allocator.add(className: AMTableData.ClassName,
			      allocator: ALFrameAllocator.Allocator(frameName: AMTableData.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMTableData(context: ctxt)
		}))
	}

	private func defineComponentFuntion(context ctxt: KEContext, viewController vcont: AMComponentViewController, resource res: KEResource) {
		/* enterView function */
		let enterfunc: @convention(block) (_ pathval: JSValue, _ argval: JSValue, _ cbfunc: JSValue) -> Void = {
			(_ paramval: JSValue, _ argval: JSValue, _ cbfunc: JSValue) -> Void in
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in
				if let src = self.enterParameter(parameter: paramval, resource: res) {
					let arg = argval.toNativeValue()
					self.enterView(viewController: vcont, context: ctxt, source: src, argument: arg, callback: cbfunc)
				}
			})
		}
		ctxt.set(name: "_enterView", function: enterfunc)

		/* leaveView function */
		let leavefunc: @convention(block) (_ retval: JSValue) -> Void = {
			(_ retval: JSValue) -> Void in
			let nval = retval.toNativeValue()
			self.leaveView(viewController: vcont, returnValue: nval)
		}
		ctxt.set(name: "leaveView", function: leavefunc)

		/* _alert */
		let alertfunc: @convention(block) (_ type: JSValue, _ msg: JSValue, _ labels: JSValue, _ cbfunc: JSValue) -> Void = {
			(_ type: JSValue, _ msg: JSValue, _ labels: JSValue, _ cbfunc: JSValue) -> Void in
			self.defineAlertFunction(type: type, message: msg, labels: labels, callback: cbfunc, viewController: vcont, context: ctxt)
		}
		ctxt.set(name: "_alert", function: alertfunc)
	}

	private func enterParameter(parameter param: JSValue, resource res: KEResource) -> AMSource? {
		if let paramstr = param.toString() {
			return .subView(res, paramstr)
		} else {
			return nil
		}
	}

	private func enterView(viewController vcont: AMComponentViewController, context ctxt: KEContext, source src: AMSource, argument arg: CNValue, callback cbfunc: JSValue) {
		if let parent = vcont.parent as? AMMultiComponentViewController {
			let vcallback: AMMultiComponentViewController.ViewSwitchCallback = {
				(_ val: CNValue) -> Void in
				CNExecuteInUserThread(level: .event, execute: {
					cbfunc.call(withArguments: [val.toJSValue(context: ctxt)])
				})
			}
			parent.pushViewController(source: src, argument: arg, callback: vcallback)
		} else {
			CNLog(logLevel: .error, message: "No parent controller")
		}
	}

	private func leaveView(viewController vcont: AMComponentViewController, returnValue retval: CNValue) {
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			if let parent = vcont.parent as? AMMultiComponentViewController {
				if !parent.popViewController(returnValue: retval) {
					CNLog(logLevel: .error, message: "Failed to pop view")
				}
			} else {
				CNLog(logLevel: .error, message: "No parent controller")
			}
		})
	}

	private func defineAlertFunction(type typ: JSValue, message msg: JSValue, labels labs: JSValue, callback cbfunc: JSValue, viewController vcont: AMComponentViewController, context ctxt: KEContext) -> Void {
		CNExecuteInMainThread(doSync: false, execute: {
			AMAlert.execute(type: typ, message: msg, labels: labs, callback: cbfunc, viewController: vcont, context: ctxt)
		})
	}
}

