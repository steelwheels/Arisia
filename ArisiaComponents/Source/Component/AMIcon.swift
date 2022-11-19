/**
 * @file	AMIcon.swift
 * @brief	Define AMIcon class
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

public class AMIcon: KCIconView, ALFrame
{
	public static let ClassName		= "Icon"

	private static let ImageItem 		= "image"
	private static let SizeItem		= "size"
	private static let SymbolItem		= "symbol"
	private static let TitleItem		= "title"

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore
	private var mPath:		ALFramePath

	public var core: ALFrameCore { get { return mFrameCore }}
	public var path: ALFramePath { get { return mPath 	}}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMIcon.ClassName, context: ctxt)
		mPath		= ALFramePath()
		let frame	= CGRect(x: 0.0, y: 0.0, width: 188, height: 21)
		super.init(frame: frame)
		mFrameCore.owner = self
	}

	public required init?(coder: NSCoder) {
		fatalError("Not supported")
	}

	static public var propertyTypes: Dictionary<String, CNValueType> { get {
		let sizetype: CNEnumType
		if let etype = CNEnumTable.currentEnumTable().search(byTypeName: "IconSize") {
			sizetype = etype
		} else {
			CNLog(logLevel: .error, message: "No enum type: \"IconSize\"", atFunction: #function, inFile: #file)
			sizetype = CNEnumType(typeName: "IconSize")
		}
		let result: Dictionary<String, CNValueType> = [
			AMIcon.ImageItem:	.stringType,
			AMIcon.SymbolItem:	.numberType,
			AMIcon.TitleItem:	.stringType,
			AMIcon.SizeItem:	.enumType(sizetype)
		]
		return result.merging(ALDefaultFrame.propertyTypes){ (a, b) in a }
	}}

	public func setup(path pth: ALFramePath, resource res: KEResource, console cons: CNConsole) -> NSError? {
		/* Set path of this frame */
		mPath = pth

		/* Set property types */
		definePropertyTypes(propertyTypes: AMIcon.propertyTypes)

		/* New image */
		var newimg: CNImage? = nil

		/* image property */
		if let ident = stringValue(name: AMIcon.ImageItem) {
			if let img = res.loadImage(identifier: ident) {
				newimg = img
			} else {
				CNLog(logLevel: .error, message: "Failed to load image: \(ident)")
			}
		}

		/* symbol property */
		if let num = numberValue(name: AMIcon.SymbolItem) {
			if newimg == nil {
				if let stype = CNSymbol.SymbolType(rawValue: num.intValue) {
					newimg = CNSymbol.shared.loadImage(type: stype)
				} else {
					CNLog(logLevel: .error, message: "Invalid raw value for CNSymbol.SymbolType: \(num.description)")
				}
			} else {
				CNLog(logLevel: .error, message: "Do not set image property and symbol property. Set one of them.")
			}
		}

		/* Load image */
		if let img = newimg {
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in self.image = img
			})
		} else {
			CNLog(logLevel: .error, message: "Failed to load image or symbol")
		}

		/* title property */
		if let title = stringValue(name: AMIcon.TitleItem) {
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in self.title = title
			})
		}

		/* Size property */
		if let num = numberValue(name: AMIcon.SizeItem) {
			if let size = CNIconSize(rawValue: num.intValue) {
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in self.size = size
				})
			} else {
				CNLog(logLevel: .error, message: "Icon size type is required but it is not.")
			}
		}

		return nil
	}
}

