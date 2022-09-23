/**
 * @file AMRootView.swift
 * @brief	Define AMRootView class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiControls
import KiwiEngine
import CoconutData
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

public class AMRootView: KCRootView, ALFrame
{
	public static let ClassName 	= "RootView"

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore

	public var core: ALFrameCore { get { return mFrameCore }}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMRootView.ClassName, context: ctxt)
		let frame	= CGRect(x: 0.0, y: 0.0, width: 188, height: 21)
		super.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		fatalError("Not supported")
	}
}

/*

public class KMButton: KCButton, AMBComponent
{
	private static let PressedItem		= "pressed"
	private static let IsEnabledItem	= "isEnabled"
	private static let TitleItem		= "title"

	private var mReactObject:	AMBReactObject?

	public var reactObject: AMBReactObject	{ get {
		if let robj = mReactObject {
			return robj
		} else {
			fatalError("No react object")
		}
	}}





	public var children: Array<AMBComponent> { get { return [] }}
	public func addChild(component comp: AMBComponent) {
		CNLog(logLevel: .error, message: "Can not add child components to Button component")
	}

	public func setup(reactObject robj: AMBReactObject, console cons: CNConsole) -> NSError? {
		mReactObject	= robj

		/* Add callbacks */
		self.buttonPressedCallback = {
			() -> Void in
			if let evtval = robj.immediateValue(forProperty: KMButton.PressedItem) {
				CNExecuteInUserThread(level: .event, execute: {
					evtval.call(withArguments: [robj])	// insert self
				})
			}
		}

		/* isEnabled property */
		addScriptedProperty(object: robj, forProperty: KMButton.IsEnabledItem)
		if let val = robj.boolValue(forProperty: KMButton.IsEnabledItem) {
			self.isEnabled = val
		} else if let _ = robj.immediateValue(forProperty: KMButton.IsEnabledItem) {
			/* Not boolean value: Keep it*/
			self.isEnabled = false
		} else {
			robj.setBoolValue(value: self.isEnabled, forProperty: KMButton.IsEnabledItem)
		}
		robj.addObserver(forProperty: KMButton.IsEnabledItem, callback: {
			(_ param: Any) -> Void in
			if let val = robj.boolValue(forProperty: KMButton.IsEnabledItem) {
				CNExecuteInMainThread(doSync: false, execute: {
					self.isEnabled = val
				})
			} else {
				let ival = robj.immediateValue(forProperty: KMButton.IsEnabledItem)
				CNLog(logLevel: .error, message: "Invalid property: name=\(KMButton.IsEnabledItem), value=\(String(describing: ival))", atFunction: #function, inFile: #file)
			}
		})

		/* title */
		addScriptedProperty(object: robj, forProperty: KMButton.TitleItem)
		if let val = robj.stringValue(forProperty: KMButton.TitleItem) {
			self.value = stringToValue(string: val)
		} else {
			let str = valueToString(value: self.value)
			robj.setStringValue(value: str, forProperty: KMButton.TitleItem)
		}
		robj.addObserver(forProperty: KMButton.TitleItem, callback: {
			(_ param: Any) -> Void in
			if let val = robj.stringValue(forProperty: KMButton.TitleItem) {
				CNExecuteInMainThread(doSync: false, execute: {
					self.value = .text(val)
				})
			} else {
				let ival = robj.immediateValue(forProperty: KMButton.TitleItem)
				CNLog(logLevel: .error, message: "Invalid property: name=\(KMButton.TitleItem), value=\(String(describing: ival))", atFunction: #function, inFile: #file)
			}
		})

		return nil
	}

	private func stringToValue(string str: String) -> KCButtonValue {
		let result: KCButtonValue
		switch str {
		case "<-":	result = .symbol(.leftArrow)
		case "->":	result = .symbol(.rightArrow)
		default:	result = .text(str)
		}
		return result
	}

	private func valueToString(value val: KCButtonValue) -> String {
		let result: String
		switch val {
		case .text(let txt):		result = txt
		case .symbol(let sym):
			switch sym {
			case .leftArrow:	result = "<-"
			case .rightArrow:	result = "->"
			@unknown default:	result = "?"
			}
		@unknown default:
			result = "?"
		}
		return result
	}

	public func accept(visitor vst: KMVisitor) {
		vst.visit(button: self)
	}
}

*/
