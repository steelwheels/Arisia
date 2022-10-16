/**
 * @file AMTableData.swift
 * @brief	Define AMTableData class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import ArisiaLibrary
import KiwiLibrary
import KiwiEngine
import CoconutData
import JavaScriptCore
import Foundation

public class AMTableData: ALFrame
{
	public static let ClassName 		= "TableData"

	private static let AppendItem		= "append"
	private static let CountItem		= "count"
	private static let StorageItem		= "storage"
	private static let PathItem		= "path"
	private static let FieldNameItem	= "fieldName"
	private static let FieldNamesItem	= "fieldNames"
	private static let NewRecordItem	= "newRecord"
	private static let SearchItem		= "search"
	private static let RecordItem		= "record"
	private static let TableItem		= "table"
	private static let UpdateItem		= "update"

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore
	private var mPath:		ALFramePath
	private var mTable: 		CNStorageTable?

	public var core: ALFrameCore { get { return mFrameCore }}
	public var path: ALFramePath { get { return mPath 	}}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMTableData.ClassName, context: ctxt)
		mPath 		= ALFramePath()
		mTable		= nil

		mFrameCore.owner = self
	}

	public func setup(path pth: ALFramePath, resource res: KEResource, console cons: CNConsole) -> NSError? {
		/* Set path of this frame */
		mPath = pth

		/* storage */
		definePropertyType(propertyName: AMTableData.StorageItem, valueType: .stringType)
		let storagename: String?
		if let name = stringValue(name: AMTableData.StorageItem) {
			storagename = name
		} else {
			storagename = nil
		}

		/* path */
		definePropertyType(propertyName: AMTableData.PathItem, valueType: .stringType)
		let pathname: String?
		if let name = stringValue(name: AMTableData.PathItem) {
			pathname = name
		} else {
			pathname = nil
		}

		/* Load storage dictionary */
		let table:   CNStorageTable
		if let tbl = loadTable(storageName: storagename, pathName: pathname, resource: res) {
			table   = tbl
		} else {
			/* Load failed, use dummy table */
			table   = CNStorageTable.loadDummyTable()
		}

		/* count (set and updated in updateTablePropeties()) */
		definePropertyType(propertyName: AMTableData.CountItem, valueType: .numberType)

		/* fieldNames (set and updated in updateTablePropeties()) */
		definePropertyType(propertyName: AMTableData.FieldNamesItem, valueType: .arrayType(.stringType))

		/* fieldName(index: number): string */
		definePropertyType(propertyName: AMTableData.FieldNameItem, valueType: .functionType(.stringType, []))
		let fnamefunc: @convention(block) (_ idxval: JSValue) -> JSValue = {
			(_ idxval: JSValue) -> JSValue in
			if idxval.isNumber {
				if let fname = table.fieldName(at: Int(idxval.toInt32())) {
					return JSValue(object: fname, in: self.core.context)
				} else {
					CNLog(logLevel: .error, message: "Invalid index range: \(idxval.toInt32())")
				}
			} else {
				CNLog(logLevel: .error, message: "Invalid parameter for \(AMTableData.FieldNameItem) method")
			}
			return JSValue(object: "", in: self.core.context)
		}
		if let funcval = JSValue(object: fnamefunc, in: core.context) {
			setValue(name: AMTableData.FieldNameItem, value: funcval)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate function", atFunction: #function, inFile: #file)
		}

		/* newRecord(): KLRecord */
		definePropertyType(propertyName: AMTableData.NewRecordItem, valueType: .functionType(.recordType(table.defaultTypes), []))
		let newrecfunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			let nrec   = table.newRecord()
			let recobj = KLRecord(record: nrec, context: self.core.context)
			if let val = KLRecord.allocate(record: recobj) {
				return val
			} else {
				return JSValue(nullIn: self.core.context)
			}
		}
		if let funcval = JSValue(object: newrecfunc, in: core.context) {
			setValue(name: AMTableData.NewRecordItem, value: funcval)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate function", atFunction: #function, inFile: #file)
		}

		/* Update read-only properties */
		updateTablePropeties()

		/* default properties */
		self.setupDefaultProperties()
		
		return nil
	}

	private func loadTable(storageName snamep: String?, pathName pnamep: String?, resource res: KEResource) -> CNStorageTable? {
		guard let sname = snamep else {
			CNLog(logLevel: .error, message: "TableData component requires the value of \(AMTableData.StorageItem) property")
			return nil
		}
		guard let pname = pnamep else {
			CNLog(logLevel: .error, message: "TableData component requires the value of \(AMTableData.PathItem) property")
			return nil
		}
		if let storage = res.loadStorage(identifier: sname) {
			switch CNValuePath.pathExpression(string: pname) {
			case .success(let path):
				return CNStorageTable(path: path, storage: storage)
			case .failure(let err):
				CNLog(logLevel: .error, message: "Failed to load tabale for TableData component: \(err.toString())")
				return nil
			}
		} else {
			CNLog(logLevel: .error, message: "Failed to load tabale for TableData component: \(AMTableData.StorageItem) = \(sname), \(AMTableData.PathItem) = \(pname)")
			return nil
		}
	}

	private func updateTablePropeties() {
		guard let table = mTable else {
			return
		}

		/* count */
		setNumberValue(name: AMTableData.CountItem, value: NSNumber(value: table.recordCount))

		/* fieldNames */
		if let fnames = JSValue(object: table.fieldNames, in: core.context) {
			setValue(name: AMTableData.FieldNamesItem, value: fnames)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate array", atFunction: #function, inFile: #file)
		}
	}
}
