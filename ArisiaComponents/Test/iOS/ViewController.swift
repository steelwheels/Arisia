/**
 * @file	ViewController.swift
 * @brief	Define ViewController class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaComponents
import KiwiEngine
import CoconutData
import UIKit

class ViewController: AMMultiComponentViewController
{
	open override func loadResource() -> KEResource {
		if let path = Bundle.main.path(forResource: "sample", ofType: "jspkg") {
			let resource = KEResource.init(packageDirectory: URL(fileURLWithPath: path))
			let loader   = KEManifestLoader()
			if let err = loader.load(into: resource) {
				CNLog(logLevel: .error, message: "Failed to load contents of sample.jspkg: \(err.toString())")
			}
			return resource
		} else {
			CNLog(logLevel: .error, message: "Failed to load sample.jspkg")
			return super.loadResource()
		}
	}

	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		/* add sub view */
		if let res = self.resource {
			let callback: AMMultiComponentViewController.ViewSwitchCallback = {
				(_ val: CNValue) -> Void in
				let msg: String
				if let str = val.toString() {
					msg = str
				} else {
					msg = "<unknown>"
				}
				CNLog(logLevel: .detail, message: "original view controller is poped: \(msg)")
			}
			let _ = super.pushViewController(source: .mainView(res), argument: CNValue.null, callback: callback)
		} else {
			CNLog(logLevel: .error, message: "Failed to get resource")
		}
	}
}


/*
//
//  ViewController.swift
//  UnitTest_iOS
//
//  Created by Tomoo Hamada on 2022/09/23.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}

*/

