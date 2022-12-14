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
			defineBuiltinFuntion(context: ctxt, viewController: vcont, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, config: conf)
		}

		importBuiltinLibrary(context: ctxt, console: cons, config: conf)

		return true
	}

	public static var builtinComponentNames: Array<String> { get {
		return [
			AMButton.ClassName,
			AMBox.ClassName,
			AMCollection.ClassName,
			AMIcon.ClassName,
			AMImage.ClassName,
			AMLabel.ClassName,
			AMRadioButtons.ClassName,
			AMStepper.ClassName,
			AMTableData.ClassName
		]
	}}

	public static func interfaceType(forComponent comp: String) -> CNInterfaceType? {
		let result: CNInterfaceType?
		switch comp {
		case AMButton.ClassName:	result = AMButton.interfaceType
		case AMBox.ClassName:		result = AMBox.interfaceType
		case AMCollection.ClassName:	result = AMCollection.interfaceType
		case AMIcon.ClassName:		result = AMIcon.interfaceType
		case AMImage.ClassName:		result = AMImage.interfaceType
		case AMLabel.ClassName:		result = AMLabel.interfaceType
		case AMRadioButtons.ClassName:	result = AMRadioButtons.interfaceType
		case AMStepper.ClassName:	result = AMStepper.interfaceType
		case AMTableData.ClassName:	result = AMTableData.interfaceType
		default:
			CNLog(logLevel: .error, message: "Unknown component name: \(comp)", atFunction: #function, inFile: #file)
			result = nil
		}
		return result
	}

	private func defineAllocators(context ctxt: KEContext) {
		let allocator = ALFrameAllocator.shared

		/* Button */
		allocator.add(className: AMButton.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMButton.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in
				return AMButton(context: ctxt)
			},
			interfaceType: AMButton.interfaceType
		))

		/* Box */
		allocator.add(className: AMBox.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMBox.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMBox(context: ctxt)
			},
			interfaceType: AMBox.interfaceType
		))

		/* Collection */
		allocator.add(className: AMCollection.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMCollection.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMCollection(context: ctxt)
			},
			interfaceType: AMCollection.interfaceType
		))

		/* Image */
		allocator.add(className: AMImage.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMImage.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMImage(context: ctxt)
			},
			interfaceType: AMImage.interfaceType
		))

		/* Icon */
		allocator.add(className: AMIcon.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMIcon.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMIcon(context: ctxt)
			},
			interfaceType: AMIcon.interfaceType
		))

		/* Label */
		allocator.add(className: AMLabel.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMLabel.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMLabel(context: ctxt)
			},
			interfaceType: AMLabel.interfaceType
		))

		/* RadioButtons */
		allocator.add(className: AMRadioButtons.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMRadioButtons.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMRadioButtons(context: ctxt)
			},
			interfaceType: AMRadioButtons.interfaceType
		))
		
		/* Stepper */
		allocator.add(className: AMStepper.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMStepper.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMStepper(context: ctxt)
			},
			interfaceType: AMStepper.interfaceType
		))

		/* TableData */
		allocator.add(className: AMTableData.ClassName,
			allocator: ALFrameAllocator.Allocator(frameName: AMTableData.ClassName, allocFuncBody: {
				(_ ctxt: KEContext) -> ALFrame? in return AMTableData(context: ctxt)
			},
			interfaceType: AMTableData.interfaceType
		))
	}

	private func defineComponentFuntion(context ctxt: KEContext, viewController vcont: AMComponentViewController, resource res: KEResource) {
		/* enterView function */
		let enterfunc: @convention(block) (_ pathval: JSValue, _ argval: JSValue, _ cbfunc: JSValue) -> Void = {
			(_ paramval: JSValue, _ argval: JSValue, _ cbfunc: JSValue) -> Void in
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in
				if let src = self.enterParameter(parameter: paramval, resource: res) {
					let conv = KLScriptValueToNativeValue()
					let arg  = conv.convert(scriptValue: argval)
					self.enterView(viewController: vcont, context: ctxt, source: src, argument: arg, callback: cbfunc)
				}
			})
		}
		ctxt.set(name: "_enterView", function: enterfunc)

		/* leaveView function */
		let leavefunc: @convention(block) (_ retval: JSValue) -> Void = {
			(_ retval: JSValue) -> Void in
			let conv = KLScriptValueToNativeValue()
			let nval = conv.convert(scriptValue: retval)
			self.leaveView(viewController: vcont, returnValue: nval)
		}
		ctxt.set(name: "leaveView", function: leavefunc)

		/* _alert */
		let alertfunc: @convention(block) (_ type: JSValue, _ msg: JSValue, _ labels: JSValue, _ cbfunc: JSValue) -> Void = {
			(_ type: JSValue, _ msg: JSValue, _ labels: JSValue, _ cbfunc: JSValue) -> Void in
			self.defineAlertFunction(type: type, message: msg, labels: labels, callback: cbfunc, viewController: vcont, context: ctxt)
		}
		ctxt.set(name: "_alert", function: alertfunc)

		/* _openPanel */
		let openPanelFunc: @convention(block) (_ titleval: JSValue, _ typeval: JSValue, _ extsval: JSValue, _ cbfunc: JSValue) -> Void = {
			(_ titleval: JSValue, _ typeval: JSValue, _ extsval: JSValue, _ cbfunc: JSValue) -> Void in
			self.openPanel(context: ctxt, titleValue: titleval, typeValue: typeval, extsValue: extsval, callbackValue: cbfunc)
		}
		ctxt.set(name: "_openPanel", function: openPanelFunc)

		/* _savePanel */
		let savePanelFunc: @convention(block) (_ titleval: JSValue, _ cbfunc: JSValue) -> Void = {
			(_ titleval: JSValue, _ cbfunc: JSValue) -> Void in
			self.savePanel(context: ctxt, titleValue: titleval, callbackValue: cbfunc)
		}
		ctxt.set(name: "_savePanel", function: savePanelFunc)
	}

	private func openPanel(context ctxt: KEContext, titleValue titleval: JSValue, typeValue typeval: JSValue, extsValue extsval: JSValue, callbackValue cbfunc: JSValue) {
		if let title = valueToString(value: titleval),
		   let type  = valueToFileType(type: typeval),
		   let exts  = valueToExtensions(extensions: extsval) {
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in self.openPanel(context: ctxt, title: title, fileType: type, extensions: exts, callback: cbfunc)
			})
		} else {
			if let param = JSValue(nullIn: ctxt) {
				cbfunc.call(withArguments: [param])
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate return value", atFunction: #function, inFile: #file)
			}
		}
	}

	#if os(OSX)
	private func openPanel(context ctxt: KEContext, title ttl: String, fileType type: CNFileType, extensions exts: Array<String>, callback cbfunc: JSValue) {
		URL.openPanel(title: ttl, type: type, extensions: exts, callback: {
			(_ urlp: URL?) -> Void in
			let param: JSValue
			if let url = urlp {
				param = JSValue(URL: url, in: ctxt)
			} else {
				param = JSValue(nullIn: ctxt)
			}
			CNExecuteInUserThread(level: .event, execute: {
				cbfunc.call(withArguments: [param])
			})
		})
	}
	#else
	private func openPanel(context ctxt: KEContext, title ttl: String, fileType type: CNFileType, extensions exts: Array<String>, callback cbfunc: JSValue) {
		guard let vcont = mViewController else {
			CNLog(logLevel: .error, message: "No view controller for openPanel", atFunction: #function, inFile: #file)
			return
		}
		// Parent controller
		let pcont  = vcont.parentController
		// Open document picker
		let picker = pcont.documentPickerViewController(callback: {
			(_ urlp: URL?) -> Void in
			let param: JSValue
			if let url = urlp {
				param = JSValue(URL: url, in: ctxt)
			} else {
				param = JSValue(nullIn: ctxt)
			}
			CNExecuteInUserThread(level: .event, execute: {
				cbfunc.call(withArguments: [param])
			})
		})
		let docdir = FileManager.default.documentDirectory
		CNLog(logLevel: .detail, message: "open-picker: \(docdir.path)", atFunction: #function, inFile: #file)
		picker.openPicker(URL: docdir)
	}
	#endif

	private func savePanel(context ctxt: KEContext, titleValue titleval: JSValue, callbackValue cbfunc: JSValue) {
		if let title = valueToString(value: titleval) {
			savePanel(context: ctxt, title: title, callback: cbfunc)
		} else {
			if let param = JSValue(nullIn: ctxt) {
				cbfunc.call(withArguments: [param])
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate return value", atFunction: #function, inFile: #file)
			}
		}
	}

	#if os(OSX)
	private func savePanel(context ctxt: KEContext, title ttl: String, callback cbfunc: JSValue) {
		URL.savePanel(title: ttl, outputDirectory: nil, callback: {
			(_ urlp: URL?) -> Void in
			let param: JSValue
			if let url = urlp {
				param = JSValue(URL: url, in: ctxt)
			} else {
				param = JSValue(nullIn: ctxt)
			}
			cbfunc.call(withArguments: [param])
		})
	}
	#else
	private func savePanel(context ctxt: KEContext, title ttl: String, callback cbfunc: JSValue) {
		if let param = JSValue(nullIn: ctxt) {
			cbfunc.call(withArguments: [param])
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate return value", atFunction: #function, inFile: #file)
		}
	}
	#endif

	private func defineBuiltinFuntion(context ctxt: KEContext, viewController vcont: AMComponentViewController, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, config conf: KEConfig) {
		/* Redefine _allocateThread method */
		let runfunc: @convention(block) (_ pathval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue = {
			(_ pathval: JSValue, _ inval: JSValue, _ outval: JSValue, _ errval: JSValue) -> JSValue in
			let newctxt  = KEContext(virtualMachine: ctxt.virtualMachine)
			let launcher = AMThreadLauncher(viewController: vcont, context: newctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, config: conf)
			let result = launcher.run(path: pathval, input: inval, output: outval, error: errval)
			return result
		}
		ctxt.set(name: "_allocateThread", function: runfunc)
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
					let conv = KLNativeValueToScriptValue(context: ctxt)
					let sval = conv.convert(value: val)
					cbfunc.call(withArguments: [sval])
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

	private func importBuiltinLibrary(context ctxt: KEContext, console cons: CNFileConsole, config conf: KEConfig)
	{
		let libnames = ["window", "panel"]
		do {
			for libname in libnames {
				if let url = CNFilePath.URLForResourceFile(fileName: libname, fileExtension: "js", subdirectory: "Library", forClass: AMLibraryCompiler.self) {
					let script = try String(contentsOf: url, encoding: .utf8)
					let _ = compileStatement(context: ctxt, statement: script, sourceFile: url, console: cons, config: conf)
				} else {
					cons.error(string: "Built-in script \"\(libname)\" is not found.\n")
				}
			}
		} catch {
			cons.error(string: "Failed to read built-in script in KiwiComponents")
		}
	}

	private func valueToString(value val: JSValue) -> String? {
		if val.isString {
			return val.toString()
		} else {
			return nil
		}
	}

	private func valueToFileType(type tval: JSValue) -> CNFileType? {
		if let num = tval.toNumber() {
			if let sel = CNFileType(rawValue: num.intValue) {
				return sel
			}
		}
		return nil
	}

	private func valueToExtensions(extensions tval: JSValue) -> Array<String>? {
		if tval.isArray {
			var types: Array<String> = []
			if let vals = tval.toArray() {
				for elm in vals {
					if let str = elm as? String {
						types.append(str)
					} else {
						return nil
					}
				}
			}
			return types
		}
		return nil
	}
}

