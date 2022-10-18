/**
 * @file	AMImage.swift
 * @brief	Define AMImage class
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

public class AMImage: KCImageView, ALFrame
{
	public static let ClassName		= "Image"

	private static let NameItem 		= "name"
	private static let ScaleItem		= "scale"

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore
	private var mPath:		ALFramePath

	public var core: ALFrameCore { get { return mFrameCore }}
	public var path: ALFramePath { get { return mPath 	}}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMImage.ClassName, context: ctxt)
		mPath		= ALFramePath()
		let frame	= CGRect(x: 0.0, y: 0.0, width: 188, height: 21)
		super.init(frame: frame)
		mFrameCore.owner = self
	}

	public required init?(coder: NSCoder) {
		fatalError("Not supported")
	}

	public func setup(path pth: ALFramePath, resource res: KEResource, console cons: CNConsole) -> NSError? {
		/* Set path of this frame */
		mPath = pth

		/* name property */
		definePropertyType(propertyName: AMImage.NameItem, valueType: .stringType)
		if let name = stringValue(name: AMImage.NameItem) {
			CNExecuteInMainThread(doSync: false, execute: {
				self.setImage(byName: name, resource: res, console: cons)
			})
		} else {
			cons.log(string: "[Error] \(AMImage.NameItem) property is required for Image component")
			self.setStringValue(name: AMImage.NameItem, value: "<no-name>")
		}
		addObserver(propertyName: AMImage.NameItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let name = param.toString() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.setImage(byName: name, resource: res, console: cons)
				})
			}
		})

		/* scale */
		definePropertyType(propertyName: AMImage.ScaleItem, valueType: .numberType)
		if let scale = numberValue(name: AMImage.ScaleItem) {
			self.scale = CGFloat(scale.doubleValue)
		} else {
			let num = NSNumber(floatLiteral: Double(self.scale))
			setNumberValue(name: AMImage.ScaleItem, value: num)
		}
		addObserver(propertyName: AMImage.ScaleItem, listnerFunction: {
			(_ param: Any) -> Void in
			if let scale = self.numberValue(name: AMImage.ScaleItem) {
				CNExecuteInMainThread(doSync: false, execute: {
					self.scale = CGFloat(scale.doubleValue)
				})
			} else {
				cons.log(string: "[Error] Invalid data type of \(AMImage.ScaleItem) parameter for Image component")
			}
		})

		/* default properties */
		self.setupDefaultProperties()
		
		return nil
	}

	private func setImage(byName name: String, resource res: KEResource, console cons: CNConsole) {
		if let img = res.loadImage(identifier: name) {
			super.image = img
		} else {
			cons.error(string: "Failed to load image named: \(name)\n")
		}
	}
}

