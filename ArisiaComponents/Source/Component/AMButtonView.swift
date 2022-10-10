/**
 * @file AMButtonView.swift
 * @brief	Define AMButtonView class
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

public class AMButtonView: KCButton, ALFrame
{
	public static let ClassName		= "ButtonView"

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
		mFrameCore	= ALFrameCore(frameName: AMButtonView.ClassName, context: ctxt)
		mPath		= ALFramePath()
		let frame	= CGRect(x: 0.0, y: 0.0, width: 188, height: 21)
		super.init(frame: frame)
		mFrameCore.owner = self
	}

	public required init?(coder: NSCoder) {
		fatalError("Not supported")
	}

	public func setup(path pth: ALFramePath, resource res: KEResource) -> NSError? {
		/* Set path of this frame */
		mPath = pth

		/* "pressed" event */
		definePropertyType(propertyName: AMButtonView.PressedItem, valueType: .functionType(.voidType, [ path.selfType ]))
		if self.value(name: AMButtonView.PressedItem) == nil {
			self.setValue(name: AMButtonView.PressedItem, value: JSValue(nullIn: core.context))
		}
		self.buttonPressedCallback = {
			() -> Void in
			if let evtval = self.value(name: AMButtonView.PressedItem) {
				if !evtval.isNull {
					CNExecuteInUserThread(level: .event, execute: {
						evtval.call(withArguments: [self.mFrameCore])	// insert self
					})
				}
			}
		}

		/* isEnabled property */
		definePropertyType(propertyName: AMButtonView.IsEnabledItem, valueType: .boolType)
		if let enable = booleanValue(name: AMButtonView.IsEnabledItem) {
			CNExecuteInMainThread(doSync: false, execute: {
				self.isEnabled = enable
			})
		} else {
			let _ = setBooleanValue(name: AMButtonView.IsEnabledItem, value: self.isEnabled)
		}
		addObserver(propertyName: AMButtonView.IsEnabledItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.isEnabled = num.boolValue
				})
			}
		})

		/* title property */
		definePropertyType(propertyName: AMButtonView.TitleItem, valueType: .stringType)
		if let str = stringValue(name: AMButtonView.TitleItem) {
			CNExecuteInMainThread(doSync: false, execute: {
				self.value = self.stringToValue(string: str)
			})
		} else {
			let str = valueToString(value: self.value)
			let _ = setStringValue(name: AMButtonView.TitleItem, value: str)
		}
		addObserver(propertyName: AMButtonView.TitleItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let str = param.toString() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.value = self.stringToValue(string: str)
				})
			}
		})

		/* default properties */
		self.setupDefaultProperties()
		
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

