/**
 * @file AMLabel.swift
 * @brief	Define AMLabel class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiLibrary
import KiwiEngine
import KiwiControls
import CoconutData
import JavaScriptCore
import Foundation

public class AMLabel: KCTextEdit, ALFrame
{
	public static let ClassName	= "Label"

	private static let TextItem	= "text"
	private static let NumberItem	= "number"

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore
	private var mPath:		ALFramePath

	public var core: ALFrameCore { get { return mFrameCore }}
	public var path: ALFramePath { get { return mPath 	}}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMLabel.ClassName, context: ctxt)
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

		definePropertyType(propertyName: AMLabel.TextItem, valueType: .stringType)
		definePropertyType(propertyName: AMLabel.NumberItem, valueType: .numberType)
		self.defineDefaultProperties()
	}

	public func connectProperties(resource res: KEResource, console cons: CNConsole) -> NSError? {
		/* text */
		if let str = stringValue(name: AMLabel.TextItem) {
			self.text = str
		} else {
			let _ = setStringValue(name: AMLabel.TextItem, value: self.text)
		}
		addObserver(propertyName: AMLabel.TextItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let str = param.toString() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.text = str
				})
			}
		})

		/* number */
		if let num = numberValue(name: AMLabel.NumberItem) {
			self.number = num
		} else {
			let num = self.number ?? NSNumber(integerLiteral: 0)
			let _ = setNumberValue(name: AMLabel.NumberItem, value: num)
		}
		addObserver(propertyName: AMLabel.NumberItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let  num = param.toNumber() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.number = num
				})
			}
		})

		/* default properties */
		self.connectDefaultProperties()
		
		return nil // noError
	}
}

