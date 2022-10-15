/**
 * @file ViewController.swift
 * @brief Define ViewController class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaComponents
import KiwiEngine
import CoconutData
#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif

class ViewController: AMMultiComponentViewController
{
	open override func loadResource() -> KEResource {
		let path: String?
		let homedir = CNPreference.shared.userPreference.homeDirectory
		if homedir.isNull {
			path = Bundle.main.path(forResource: "Welcome", ofType: "jspkg")
		} else {
			path = Bundle.main.path(forResource: "Home", ofType: "jspkg")
		}
		/* Load resource */
		if let path = path {
			let resource = KEResource.init(packageDirectory: URL(fileURLWithPath: path))
			let loader   = KEManifestLoader()
			if let err = loader.load(into: resource) {
				CNLog(logLevel: .error, message: "Failed to load manifest: \(err.toString())")
			}
			return resource
		} else {
			CNLog(logLevel: .error, message: "Failed to load package")
			fatalError("Failed to load package")
		}
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		/* Update log level */
		//let _ = KCLogManager.shared
		//let syspref = CNPreference.shared.systemPreference
		//syspref.logLevel = .detail

		/* Add subview */
		if let res = self.resource {
			let cbfunc: AMMultiComponentViewController.ViewSwitchCallback = {
				(_ val: CNValue) -> Void in
				let valstr: String
				if let str = val.toString() {
					valstr = str
				} else {
					valstr = "<unknown>"
				}
				NSLog("mainView: return_val=\(valstr)")
			}
			let _ = super.pushViewController(source: .mainView(res), argument: CNValue.null, callback: cbfunc)
		}
	}
}
