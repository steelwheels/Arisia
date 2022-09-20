/**
 * @file	KMMultiComponentViewController.swift
 * @brief	Define KMMultiComponentViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import KiwiControls
import KiwiEngine
import CoconutData
import Foundation

open class KMMultiComponentViewController: KCMultiViewController
{
	public typealias ViewSwitchCallback = KCMultiViewController.ViewSwitchCallback

	private enum Context {
		case	context(KEContext)
		case	none
	}

	private var mEnvironment:			CNEnvironment
	private var mResource: KEResource?		= nil
	private var mProcessManager			= CNProcessManager()

	public var resource: KEResource? { get { return mResource }}
	public var processManager: CNProcessManager { get { return mProcessManager }}

	@objc required dynamic public init?(coder: NSCoder) {
		mEnvironment = CNEnvironment()
		super.init(coder: coder)
	}

	open override func viewDidLoad() {
		mEnvironment = CNEnvironment()
		mResource    = loadResource()
		super.viewDidLoad()
	}

	open func loadResource() -> KEResource {
		return KEResource(packageDirectory: Bundle.main.bundleURL)
	}

	public func pushViewController(source src: KMSource, argument arg: CNValue, callback cbfunc: @escaping ViewSwitchCallback) {
		let viewctrl = KMComponentViewController(parentViewController: self)
		viewctrl.setup(source: src, argument: arg, processManager: mProcessManager, environment: mEnvironment)
		super.pushViewController(viewController: viewctrl, callback: cbfunc)
	}

	public override func popViewController(returnValue retval: CNValue) -> Bool {
		/* Pop the view */
		return super.popViewController(returnValue: retval)
	}
}

