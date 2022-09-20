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

public enum KMSource {
	case	mainView(KEResource)			// The resource contains the main view
	case	subView(KEResource, String)		// The resource contains the sub view, the sub view name
}

open class KMComponentViewController: KCSingleViewController
{
	private var mContext:			KEContext
	private var mSource:			KMSource?
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

	public func setup(source src: KMSource, argument arg: CNValue, processManager pmgr: CNProcessManager, environment env: CNEnvironment) {
		mSource		= src
		mArgument	= arg
		mProcessManager	= pmgr
		mEnvironment	= env
	}

	open override func loadContext() -> KCView? {
		let console  = super.globalConsole

		guard let src = mSource else {
			console.error(string: "No source file for new view\n")
			return nil
		}

		guard let procmgr = mProcessManager else {
			console.error(string: "No process manager\n")
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
				console.error(string: "Failed to load main view\n")
				return nil
			}
		case .subView(let res, let name):
			if let scr = res.loadSubview(identifier: name) {
				script		= scr
				srcfile		= res.URLOfSubView(identifier: name)
				resource	= res
			} else {
				console.error(string: "Failed to load sub view named: \(name)\n")
				return nil
			}
		}
		mResource = resource

		let terminfo = CNTerminalInfo(width: 80, height: 25)
		let loglevel = CNPreference.shared.systemPreference.logLevel
		let config   = KEConfig(applicationType: .window, doStrict: true, logLevel: loglevel)

		if loglevel.isIncluded(in: .detail) {
			let txt = resource.toText()
			console.print(string: "Resource for view\n")
			console.print(string: txt.toStrings().joined(separator: "\n"))
		}

		/* Define global variable: Argument */
		let obj = mArgument.toJSValue(context: self.context)
		self.context.set(name: "Argument", value: obj)

		/* Compile library */
		guard self.compile(viewController: self, context: self.context, resource: resource, processManager: procmgr, terminalInfo: terminfo, environment: self.environment, console: console, config: config) else {
			console.error(string: "Failed to compile base\n")
			return nil
		}

		/* Parse the Arisia script */
		let root: ALFrameIR
		let parser = ALParser()
		switch parser.parse(source: script, sourceFile: srcfile) {
		case .success(let frame):
			root = frame
		case .failure(let err):
			console.error(string: err.toString())
			return nil
		}

		/* Compile the frame */
		let jscode : CNTextSection
		let langconf = ALLanguageConfig()
		let compiler = ALScriptCompiler(config: langconf)
		switch compiler.compile(rootFrame: root) {
		case .success(let txt):
			jscode = txt
		case .failure(let err):
			console.error(string: err.toString())
			return nil
		}

		/* dump the frame */
		if loglevel.isIncluded(in: .detail) {
			console.print(string: "[Output transpiled code]\n")
			let txt = jscode.toStrings().joined(separator: "\n")
			console.print(string: txt + "\n")
		}


		/*

		let ambparser = AMBParser()
		let frame: AMBFrame
		switch ambparser.parse(source: script as String, sourceFile: srcfile) {
		case .success(let val):
			if let frm = val as? AMBFrame {
				frame = frm
			} else {
				console.error(string: "Error: Frame object is required\n")
				return nil
			}
		case .failure(let err):
			console.error(string: "Error: \(err.toString())\n")
			return nil
		}



		/* Allocate the component */
		let compiler = AMBFrameCompiler()
		let mapper   = KMComponentMapper()
		let topcomp: AMBComponent
		switch compiler.compile(frame: frame, mapper: mapper, context: context, processManager: procmgr, resource: resource, environment: self.environment, config: config, console: console) {
		case .success(let comp):
			topcomp = comp
			/* dump the component */
			if loglevel.isIncluded(in: .detail) {
				console.print(string: "[Output of Amber Compiler]\n")
				let txt = comp.toText().toStrings().joined(separator: "\n")
				console.print(string: txt + "\n")
			}
		case .failure(let err):
			console.error(string: "Error: \(err.toString())\n")
			return nil
		}*/

		/* Setup root view*/
		//return topcomp as? KCView
	}

	private func compile(viewController vcont: KMComponentViewController, context ctxt: KEContext, resource res: KEResource, processManager procmgr: CNProcessManager, terminalInfo terminfo: CNTerminalInfo, environment env: CNEnvironment, console cons: CNFileConsole, config conf: KEConfig) -> Bool {
		var result      = false
		let libcompiler = KLLibraryCompiler()
		if libcompiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) {
			let alcompiler = ALLibraryCompiler()
			if alcompiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf) {
				let compcompiler = KMLibraryCompiler(viewController: vcont)
				result = compcompiler.compile(context: ctxt, resource: res, processManager: procmgr, terminalInfo: terminfo, environment: env, console: cons, config: conf)
			}
		}
		return result
	}

	open override func errorContext() -> KCView {
		let procmgr: CNProcessManager
		if let mgr = mProcessManager {
			procmgr = mgr
		} else {
			procmgr = CNProcessManager()
		}
		let resource: KEResource
		if let res = mResource {
			resource = res
		} else {
			resource = KEResource(packageDirectory: Bundle.main.bundleURL)
		}
		let environment: CNEnvironment
		if let env = mEnvironment {
			environment = env
		} else {
			environment = CNEnvironment()
		}

		let frame = AMBFrame(className: "Object", instanceName: "ErrorContext")
		let robj  = AMBReactObject(frame: frame, context: mContext, processManager: procmgr, resource: resource, environment: environment)

		let box  = KMStackView()
		if let err = box.setup(reactObject: robj, console: super.globalConsole) {
			super.globalConsole.error(string: "Failed to setup error context: \(err.description)")
		}
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
			if let parent = self.parentController as? KMMultiComponentViewController {
				if parent.popViewController(returnValue: .nullValue) {
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

	#if os(OSX)
	open override func viewDidLoad() {
		super.viewDidLoad()
		doViewDidLoad()
	}
	#else
	open override func viewDidLoad() {
		super.viewDidLoad()
		doViewDidLoad()
	}
	#endif

	private func doViewDidLoad() {
		/* call init methods */
		if !mDidAlreadyInitialized {
			/* Execute the component */
			if let root = super.rootView {
				if root.hasCoreView {
					let exec = AMBComponentExecutor(console: self.globalConsole)
					let comp:AMBComponent = root.getCoreView()
					exec.exec(component: comp, console: self.globalConsole)
				} else {
					CNLog(logLevel: .error, message: "No core view in root", atFunction: #function, inFile: #file)
				}
			}
			mDidAlreadyInitialized = true
		}
	}

	#if os(OSX)
	open override func viewDidAppear() {
		super.viewDidAppear()
		doViewDidAppear()
	}
	#else
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		doViewDidAppear()
	}
	#endif

	private func doViewDidAppear() {
		/* Link components */
		if !mDidAlreadyLinked {
			if let res = mResource, let root = self.rootView {
				let linker = KMComponentLinker(viewController: self, resource: res)
				for subview in root.subviews {
					if let subcomp = subview as? AMBComponent {
						linker.visit(component: subcomp)
					}
				}
				/* Replace global console */
				if let console = linker.result {
					super.globalConsole = console
				}
			}
			mDidAlreadyLinked = true
		}
		/* dump for debug */
		if CNPreference.shared.systemPreference.logLevel.isIncluded(in: .detail) {
			let cons  = super.globalConsole
			if let root = self.rootView {
				let dumper = KCViewDumper()
				dumper.dump(view: root, console: cons)
			} else {
				cons.error(string: "No root view")
			}
		}
	}
}
