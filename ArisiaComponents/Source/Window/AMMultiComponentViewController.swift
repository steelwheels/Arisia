/**
 * @file	AMMultiComponentViewController.swift
 * @brief	Define AMMultiComponentViewController class
 * @par Copyright
 *   Copyright (C) 2020-2022 Steel Wheels Project
 */

import KiwiControls
import KiwiEngine
import CoconutData
import Foundation

open class AMMultiComponentViewController: KCMultiViewController
{
	public typealias ViewSwitchCallback = KCMultiViewController.ViewSwitchCallback

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

	public func pushViewController(source src: AMSource, argument arg: CNValue, callback cbfunc: @escaping ViewSwitchCallback) {
		let viewctrl = AMComponentViewController(parentViewController: self)
		viewctrl.setup(source: src, argument: arg, processManager: mProcessManager, environment: mEnvironment)
		super.pushViewController(viewController: viewctrl, callback: cbfunc)
	}

	public override func popViewController(returnValue retval: CNValue) -> Bool {
		/* Pop the view */
		return super.popViewController(returnValue: retval)
	}
}

