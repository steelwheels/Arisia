/**
 * @file AMButton.swift
 * @brief	Define AMButton class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiControls
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation
#if os(iOS)
import UIKit
#endif
import Foundation

public class AMButton: KCButton, ALFrame
{
	public static let ClassName		= "Button"

	private static let PressedItem		= "pressed"
	private static let IsEnabledItem	= "isEnabled"
	private static let TitleItem		= "title"

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore
	private var mPath:		ALFramePath

	public var core: ALFrameCore { get { return mFrameCore }}
	public var path: ALFramePath { get { return mPath 	}}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMButton.ClassName, context: ctxt)
		mPath		= ALFramePath()
		let frame	= CGRect(x: 0.0, y: 0.0, width: 188, height: 21)
		super.init(frame: frame)
		mFrameCore.owner = self
	}

	public required init?(coder: NSCoder) {
		fatalError("Not supported")
	}

	public func defineProperties(path pth: ALFramePath) {
		/* Set path of this frame */
		mPath = pth

		definePropertyType(propertyName: AMButton.PressedItem, valueType: .functionType(.voidType, [ path.selfType ]))
		definePropertyType(propertyName: AMButton.IsEnabledItem, valueType: .boolType)
		definePropertyType(propertyName: AMButton.TitleItem, valueType: .stringType)
		self.defineDefaultProperties()
	}

	public func connectProperties(resource res: KEResource, console cons: CNConsole) -> NSError? {
		/* "pressed" event */
		if self.value(name: AMButton.PressedItem) == nil {
			self.setValue(name: AMButton.PressedItem, value: JSValue(nullIn: core.context))
		}
		self.buttonPressedCallback = {
			() -> Void in
			if let evtval = self.value(name: AMButton.PressedItem) {
				if !evtval.isNull {
					CNExecuteInUserThread(level: .event, execute: {
						evtval.call(withArguments: [self.mFrameCore])	// insert self
					})
				}
			}
		}

		/* isEnabled property */
		if let enable = booleanValue(name: AMButton.IsEnabledItem) {
			CNExecuteInMainThread(doSync: false, execute: {
				self.isEnabled = enable
			})
		} else {
			let _ = setBooleanValue(name: AMButton.IsEnabledItem, value: self.isEnabled)
		}
		addObserver(propertyName: AMButton.IsEnabledItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.isEnabled = num.boolValue
				})
			}
		})

		/* title property */
		if let str = stringValue(name: AMButton.TitleItem) {
			CNExecuteInMainThread(doSync: false, execute: {
				self.value = self.stringToValue(string: str)
			})
		} else {
			let str = valueToString(value: self.value)
			let _ = setStringValue(name: AMButton.TitleItem, value: str)
		}
		addObserver(propertyName: AMButton.TitleItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let str = param.toString() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.value = self.stringToValue(string: str)
				})
			}
		})

		/* default properties */
		self.connectDefaultProperties()
		
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
}

