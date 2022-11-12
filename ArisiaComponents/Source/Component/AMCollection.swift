/**
 * @file AMCollection.swift
 * @brief	Define AMCollection class
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

public class AMCollection: KCCollectionView, ALFrame
{
	public static let ClassName		= "Collection"

	private static let CollectionItem	= "collection"
	private static let ColumnNumberItem	= "columnNumber"
	private static let PressedItem 		= "pressed"
	private static let TotalNumberItem	= "totalNumber"

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore
	private var mPath:		ALFramePath

	public var core: ALFrameCore { get { return mFrameCore }}
	public var path: ALFramePath { get { return mPath 	}}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMCollection.ClassName, context: ctxt)
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

		definePropertyType(propertyName: AMCollection.ColumnNumberItem, valueType: .numberType)
		definePropertyType(propertyName: AMCollection.TotalNumberItem, valueType: .functionType(.numberType, []))
		definePropertyType(propertyName: AMCollection.CollectionItem, valueType: .arrayType(.stringType))
		definePropertyType(propertyName: AMCollection.PressedItem, valueType: .functionType(.voidType, [ path.selfType, .numberType, .numberType ]))
		self.defineDefaultProperties()
	}

	public func connectProperties(resource res: KEResource, console cons: CNConsole) -> NSError? {
		/* columnNumber */
		if let colnum = numberValue(name: AMCollection.ColumnNumberItem) {
			CNExecuteInMainThread(doSync: false, execute: {
				self.numberOfColumuns = colnum.intValue
			})
		} else {
			let num = NSNumber(value: self.numberOfColumuns)
			let _ = setNumberValue(name: AMCollection.ColumnNumberItem, value: num)
		}
		addObserver(propertyName: AMCollection.ColumnNumberItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				CNExecuteInMainThread(doSync: false, execute: {
					self.numberOfColumuns = num.intValue
				})
			}
		})

		/* totalNumber() */
		let totalfunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let num = self.numberOfItems(inSection: 0) ?? 0
			return JSValue(int32: Int32(num), in: self.mContext)
		}
		if let funcval = JSValue(object: totalfunc, in: core.context) {
			setValue(name: AMCollection.TotalNumberItem, value: funcval)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate function", atFunction: #function, inFile: #file)
		}

		/* collection */
		if let cols = arrayValue(name: AMCollection.CollectionItem) as? Array<String> {
			setCollections(collections: cols, resource: res, console: cons)
		} else {
			setArrayValue(name: AMCollection.CollectionItem, value: [])
		}
		addObserver(propertyName: AMCollection.CollectionItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if param.isArray {
				if let cols = param.toArray() as? Array<String> {
					self.setCollections(collections: cols, resource: res, console: cons)
				}
			}
			cons.error(string: "Invalid data type for \(AMCollection.CollectionItem) in Collection component")
		})

		/* pressed event */
		if self.value(name: AMCollection.PressedItem) == nil {
			/* pressed event is not implemented */
			self.setValue(name: AMCollection.PressedItem, value: JSValue(nullIn: self.mContext))
		}
		super.set(selectionCallback: {
			(_ section: Int, _ item: Int) -> Void in
			if let evtval = self.value(name: AMCollection.PressedItem) {
				if !evtval.isNull {
					if let secval  = JSValue(int32: Int32(section), in: self.mContext),
					   let itemval = JSValue(int32: Int32(item), in: self.mContext) {
						CNExecuteInUserThread(level: .event, execute: {
							evtval.call(withArguments: [self.mFrameCore, secval, itemval])	// insert self
						})
					}
				}
			}
		})

		/* default properties */
		self.connectDefaultProperties()
		
		return nil
	}

	private func setCollections(collections cols: Array<String>, resource res: KEResource, console cons: CNConsole) {
		var items: Array<CNCollection.Item> = []
		for cname in cols {
			if let u = res.URLOfImage(identifier: cname) {
				items.append(CNCollection.Item.image(u))
			} else {
				cons.print(string: "[Error] No image item named \"\(cname)\" for collection component")
			}
		}
		if items.count > 0 {
			CNExecuteInMainThread(doSync: false, execute: {
				let collection = CNCollection()
				collection.add(header: "", footer: "", items: items)
				super.store(data: collection)
			})
		} else {
			cons.print(string: "[Error] No items for collection component")
		}
	}
}

