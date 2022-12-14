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

	private static let PressedItem		= "pressed"
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

	static public var interfaceType: CNInterfaceType { get {
		let ifname = ALFunctionInterface.defaultInterfaceName(frameName: AMIcon.ClassName)
		if let iftype = CNInterfaceTable.currentInterfaceTable().search(byTypeName: ifname) {
			return iftype
		} else {
			let sizetype: CNEnumType
			if let etype = CNEnumTable.currentEnumTable().search(byTypeName: "SymbolSize") {
				sizetype = etype
			} else {
				CNLog(logLevel: .error, message: "No enum type: \"SymbolSize\"", atFunction: #function, inFile: #file)
				sizetype = CNEnumType(typeName: "SymbolSize")
			}
			let baseif = ALDefaultFrame.interfaceType
			let ptypes: Dictionary<String, CNValueType> = [
				AMIcon.PressedItem:	.functionType(.voidType, [ .interfaceType(baseif) ]),
				AMIcon.SymbolItem:	.stringType,
				AMIcon.TitleItem:	.stringType,
				AMIcon.SizeItem:	.enumType(sizetype)
			]
			let newif = CNInterfaceType(name: ifname, base: baseif, types: ptypes)
			CNInterfaceTable.currentInterfaceTable().add(interfaceType: newif)
			return newif
		}
	}}

	public func setup(path pth: ALFramePath, resource res: KEResource, console cons: CNConsole) -> NSError? {
		/* Set path of this frame */
		mPath = pth

		/* Set property types */
		defineInterfaceType(interfaceType: AMIcon.interfaceType)

		/* Set default properties */
		self.setupDefaulrProperties()

		/* New image */
		var newsym: CNSymbol? = nil

		/* symbol property */
		if let str = stringValue(name: AMIcon.SymbolItem) {
			if let sym = CNSymbol.decode(fromName: str) {
				newsym = sym
			} else {
				CNLog(logLevel: .error, message: "[Error] Unknown symbol name: \(str)")
			}
		}

		/* Assign dummy image */
		if newsym == nil {
			CNLog(logLevel: .error, message: "[Error] No symbol definition")
			newsym = .questionmark
		}

		/* Load image */
		if let sym = newsym {
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in self.symbol = sym
			})
		}

		/* title property */
		if let title = stringValue(name: AMIcon.TitleItem) {
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in self.title = title
			})
		} else {
			setStringValue(name: AMIcon.TitleItem, value: self.title)
		}
		addObserver(propertyName: AMIcon.TitleItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let title = param.toString() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.title = title
				})
			}
		})

		/* Size property */
		if let num = numberValue(name: AMIcon.SizeItem) {
			if let size = CNSymbolSize(rawValue: num.intValue) {
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in self.size = size
				})
			} else {
				CNLog(logLevel: .error, message: "Icon size type is required but it is not.")
			}
		} else {
			let num = NSNumber(integerLiteral: self.size.rawValue)
			setNumberValue(name: AMIcon.SizeItem, value: num)
		}
		addObserver(propertyName: AMIcon.SizeItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				if let size = CNSymbolSize(rawValue: num.intValue) {
					CNExecuteInMainThread(doSync: false, execute: {
						self.size = size
					})
				} else {
					CNLog(logLevel: .error, message: "\(AMIcon.SizeItem) property in \(AMIcon.ClassName) component must have SymbolSize type")
				}
			}
		})

		/* "pressed" event */
		if self.value(name: AMIcon.PressedItem) == nil {
			self.setValue(name: AMIcon.PressedItem, value: JSValue(nullIn: core.context))
		}
		self.buttonPressedCallback = {
			() -> Void in
			if let evtval = self.value(name: AMIcon.PressedItem) {
				if !evtval.isNull {
					CNExecuteInUserThread(level: .event, execute: {
						evtval.call(withArguments: [self.mFrameCore])	// insert self
					})
				}
			}
		}

		return nil
	}
}

