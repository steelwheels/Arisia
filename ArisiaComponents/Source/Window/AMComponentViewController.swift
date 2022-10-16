/**
 * @file	AMComponentViewController.swift
 * @brief	Define AMComponentViewController class
 * @note This file is copied from KMComponentViewController.swift in KiwiComponent framework
 * @par Copyright
 *   Copyright (C) 2020-2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiControls
import KiwiEngine
import KiwiLibrary
import CoconutData
import JavaScriptCore
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

public enum AMSource {
	case	mainView(KEResource)			// The resource contains the main view
	case	subView(KEResource, String)		// The resource contains the sub view, the sub view name
}

open class AMComponentViewController: KCSingleViewController
{
	private var mContext:			KEContext
	private var mSource:			AMSource?
	private var mArgument:			CNValue
	private var mProcessManager:		CNProcessManager?
	private var mResource:			KEResource?
	private var mEnvironment:		CNEnvironment?
	private var mDidAlreadyLinked:		Bool
	private var mDidAlreadyInitialized:	Bool

	public override init(parentViewController parent: KCMultiViewController){
		guard let vm = JSVirtualMachine() else {
			fatalError("Failed to allocate VM")
		}
		mContext		= KEContext(virtualMachine: vm)
		mSource			= nil
		mArgument		= CNValue.null
		mProcessManager		= nil
		mResource		= nil
		mEnvironment		= nil
		mDidAlreadyLinked	= false
		mDidAlreadyInitialized	= false
		super.init(parentViewController: parent)
	}

	@objc required dynamic public init?(coder: NSCoder) {
		guard let vm = JSVirtualMachine() else {
			fatalError("Failed to allocate VM")
		}
		mContext		= KEContext(virtualMachine: vm)
		mSource			= nil
		mArgument		= CNValue.null
		mProcessManager		= nil
		mResource		= nil
		mEnvironment		= nil
		mDidAlreadyLinked	= false
		mDidAlreadyInitialized	= false
		super.init(coder: coder)
	}

	public var context: KEContext { get { return mContext }}

	private var environment: CNEnvironment {
		get {
			if let env = mEnvironment {
				return env
			} else {
				CNLog(logLevel: .error, message: "No inherited environment", atFunction: #function, inFile: #file)
				return CNEnvironment()
			}
		}
	}

	public func setup(source src: AMSource, argument arg: CNValue, processManager pmgr: CNProcessManager, environment env: CNEnvironment) {
		mSource		= src
		mArgument	= arg
		mProcessManager	= pmgr
		mEnvironment	= env
	}

	open override func loadContext() -> KCView? {
		let console  = super.globalConsole

		guard let src = mSource else {
			console.log(string: "No source file for new view\n")
			return nil
		}

		guard let procmgr = mProcessManager else {
			console.log(string: "No process manager\n")
			return nil
		}

		let script:	String
		let srcfile:	URL?
		let resource:	KEResource
		switch src {
		case .mainView(let res):
			if let scr = res.loadView() {
				script		= scr
				srcfile		= res.URLOfView()
				resource	= res
			} else {
				console.log(string: "Failed to load main view\n")
				return nil
			}
		case .subView(let res, let name):
			if let scr = res.loadSubview(identifier: name) {
				script		= scr
				srcfile		= res.URLOfSubView(identifier: name)
				resource	= res
			} else {
				console.log(string: "Failed to load sub view named: \(name)\n")
				return nil
			}
		}
		mResource = resource

		let terminfo = CNTerminalInfo(width: 80, height: 25)
		let loglevel = CNPreference.shared.systemPreference.logLevel
		let config   = ALConfig(applicationType: .window, doStrict: true, logLevel: loglevel)

		if loglevel.isIncluded(in: .detail) {
			let txt = resource.toText()
			console.log(string: "Resource for view")
			console.log(string: txt.toStrings().joined(separator: "\n"))
		}

		/* Define global variable: Argument */
		let obj = mArgument.toJSValue(context: self.context)
		self.context.set(name: "Argument", value: obj)

		guard self.compileLibrary(viewController: self, context: self.context, resource: resource, processManager: procmgr, terminalInfo: terminfo, environment: self.environment, console: console, config: config) else {
			console.log(string: "Failed to compile base\n")
			return nil
		}

		/* Compile library */
		let isarisia: Bool
		switch isArisiaScriptFile(sourceFile: srcfile) {
		case .success(let result):
			isarisia = result
		case .failure(let err):
			console.log(string: "[Error] \(err.toString())\n")
			return nil
		}

		let jscode: String
		if isarisia {
			//NSLog("Compile ArisiaScript: src=\(String(describing: srcfile?.path))")
			if let txt = compileArisiaScript(script: script, sourceFile: srcfile, console: console, config: config) {
				jscode = txt.toStrings().joined(separator: "\n")
			} else {
				console.log(string: "Failed to compile ArisiaScript\n")
				return nil
			}
		} else {
			//NSLog("Read JavaScript: src=\(String(describing: srcfile?.path))")
			jscode = script // treat as JavaScript code
		}

		/* Execute the script */
		let executor = ALScriptExecutor(config: config)
		guard let rootview = executor.execute(context: context, script: jscode, sourceFile: srcfile, resource: resource, console: console) else {
			let fname: String
			if let url = srcfile {
				fname = ": " + url.path
			} else {
				fname = ""
			}
			console.log(string: "[Error] Failed to compile script\(fname)")
			return nil
		}

		/* Return the root view */
		if let view = rootview as? KCView {
			return view
		} else {
			console.log(string: "[Error] The root frame is not view")
			return nil
		}
	}

	private func isArisiaScriptFile(sourceFile url: URL?) -> Result<Bool, NSError> {
		if let u = url {
			if let lang = ALLanguage.judge(byFileName: u.path) {
				let result: Bool
				switch lang {
				case .JavaScript:
					result = false
				case .ArisiaScript:
					result = true
				case .TypeScript:
					return .failure(NSError.fileError(message: "Can not compile TypeScript file"))
				@unknown default:
					return .failure(NSError.fileError(message: ""))
				}
				return .success(result)
			} else {
				return .failure(NSError.fileError(message: "Unknown source file exptension: \(u.path)"))
			}
		} else {
			return .failure(NSError.fileError(message: "No source file name. Can not decide Language"))
		}
	}

	private func compileLibrary(viewController vcont: AMComponentViewController, context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		let compcompiler = AMLibraryCompiler(viewController: vcont)
		return compcompiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf)
	}

	private func compileArisiaScript(script scr: String, sourceFile srcfile: URL?, console cons: CNFileConsole, config conf: ALConfig) -> CNTextSection? {
		/* Parse the Arisia script */
		let rootir: ALFrameIR
		let parser = ALParser(config: conf)
		switch parser.parse(source: scr, sourceFile: srcfile) {
		case .success(let frame):
			rootir = frame
		case .failure(let err):
			cons.error(string: err.toString())
			return nil
		}

		/* Compile the frame into JavaScript */
		let jscode: CNTextSection
		let compiler = ALScriptCompiler(config: conf)
		switch compiler.compile(rootFrame: rootir, language: .JavaScript) {
		case .success(let txt):
			jscode = txt
		case .failure(let err):
			cons.error(string: err.toString())
			return nil
		}

		/* dump the frame */
		let loglevel = CNPreference.shared.systemPreference.logLevel
		if loglevel.isIncluded(in: .detail) {
			cons.print(string: "[Output transpiled code]\n")
			let txt = jscode.toStrings().joined(separator: "\n")
			cons.log(string: txt)
		}
		return jscode
	}

	open override func errorContext() -> KCView {
		let box = KCStackView()
		box.axis = .vertical

		let message  = KCTextEdit()
		message.isBold	   = true
		message.isEditable = false
		message.text       = "Failed to load context"
		box.addArrangedSubView(subView: message)

		let button = KCButton()
		button.value = .text("Continue")
		button.buttonPressedCallback = {
			() -> Void in
			let cons  = super.globalConsole
			if let parent = self.parentController as? AMMultiComponentViewController {
				if parent.popViewController(returnValue: CNValue.null) {
					cons.error(string: "Force to return previous view\n")
				} else {
					cons.error(string: "Failed to pop view\n")
				}
			} else {
				cons.error(string: "No parent controller\n")
			}
		}
		box.addArrangedSubView(subView: button)

		return box
	}
}

