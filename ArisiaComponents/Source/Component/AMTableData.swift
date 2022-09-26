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
	private var mTable: 		CNStorageTable?

	public var core: ALFrameCore { get { return mFrameCore }}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMStackView.ClassName, context: ctxt)
		mTable		= nil

		mFrameCore.owner = self
	}

	public func setup(resource res: KEResource) -> NSError? {
		/* storage */
		definePropertyType(propertyName: AMTableData.StorageItem, valueType: .stringType)
		let storagename: String
		if let name = stringValue(name: AMTableData.StorageItem) {
			storagename = name
		} else {
			return NSError.parseError(message: "The TableData frame requires \(AMTableData.StorageItem) property.")
		}

		/* path */
		definePropertyType(propertyName: AMTableData.PathItem, valueType: .stringType)
		let pathname: String
		if let name = stringValue(name: AMTableData.PathItem) {
			pathname = name
		} else {
			return NSError.parseError(message: "The TableData frame requires \(AMTableData.PathItem) property.")
		}

		/* Load storage dictionary */
		let table: CNStorageTable
		if let storage = res.loadStorage(identifier: storagename) {
			switch CNValuePath.pathExpression(string: pathname) {
			case .success(let path):
				table = CNStorageTable(path: path, storage: storage)
				mTable = table
			case .failure(let err):
				return err
			}
		} else {
			return NSError.fileError(message: "Failed to load storage named: \(storagename)")
		}

		/* count (updated in updateTablePropeties()) */
		definePropertyType(propertyName: AMTableData.CountItem, valueType: .numberType)

		/* fieldNames (updated in updateTablePropeties()) */
		definePropertyType(propertyName: AMTableData.FieldNameItem, valueType: .arrayType(.stringType))

		/* fieldName(index: number): string | null */
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
			return JSValue(nullIn: self.core.context)
		}
		if let funcval = JSValue(object: fnamefunc, in: core.context) {
			setValue(name: AMTableData.FieldNameItem, value: funcval)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate function", atFunction: #function, inFile: #file)
		}

		/* newRecord(): KLRecord */
		definePropertyType(propertyName: AMTableData.NewRecordItem, valueType: .anyType)
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

		return nil
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

/*

public class KMTableData: AMBComponentObject
{


	private var mEventCallbackId:	Int?	= nil
	private var mUpdateCount:	Int	= 0

	deinit {
		if let table = mTable, let eid = mEventCallbackId {
			table.removeEventFunction(eventFuncId: eid)
		}
	}

	public override func setup(reactObject robj: AMBReactObject, console cons: CNConsole) -> NSError? {
		/* update count */
		addScriptedProperty(object: robj, forProperty: KMTableData.UpdateItem)
		robj.setNumberValue(value: NSNumber(integerLiteral: mUpdateCount), forProperty: KMTableData.UpdateItem)
		mUpdateCount += 1

		/* record(index) */
		addScriptedProperty(object: robj, forProperty: KMTableData.RecordItem)
		let recfunc: @convention(block) (_ idxval: JSValue) -> JSValue = {
			(_ idxval: JSValue) -> JSValue in
			if idxval.isNumber {
				if let rec = table.record(at: Int(idxval.toInt32())) {
					let recobj = KLRecord(record: rec, context: robj.context)
					if let val = KLRecord.allocate(record: recobj) {
						return val
					} else {
						CNLog(logLevel: .error, message: "Failed to allocate record")
					}
				} else {
					CNLog(logLevel: .error, message: "Unexpected index range: \(idxval.toInt32())")
				}
			}
			return JSValue(nullIn: robj.context)
		}
		robj.setImmediateValue(value: JSValue(object: recfunc, in: robj.context), forProperty: KMTableData.RecordItem)

		/* append(record) */
		addScriptedProperty(object: robj, forProperty: KMTableData.AppendItem)
		let appendfunc: @convention(block) (_ recval: JSValue) -> JSValue = {
			(_ recval: JSValue) -> JSValue in
			if recval.isObject {
				if let rec = recval.toObject() as? KLRecord {
					table.append(record: rec.core())
				} else {
					CNLog(logLevel: .error, message: "Failed to convert to record")
				}
			} else {
				CNLog(logLevel: .error, message: "Not record parameter: \(recval)")
			}
			return JSValue(nullIn: robj.context)
		}
		robj.setImmediateValue(value: JSValue(object: appendfunc, in: robj.context), forProperty: KMTableData.AppendItem)

		/* search(field, value) */
		addScriptedProperty(object: robj, forProperty: KMTableData.SearchItem)
		let searchfunc: @convention(block) (_ field: JSValue, _ value: JSValue) -> JSValue = {
			(_ field: JSValue, _ value: JSValue) -> JSValue in
			var result: Array<KLRecord> = []
			if let fname = field.toString() {
				let nval = value.toNativeValue()
				let recs = table.search(value: nval, forField: fname)
				result.append(contentsOf: recs.map {KLRecord(record: $0, context: robj.context) } )
			}
			if let resobj = KLRecord.allocate(records: result, context: robj.context) {
				return resobj
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate records", atFunction: #function, inFile: #file)
				return JSValue(newArrayIn: robj.context)
			}
		}
		robj.setImmediateValue(value: JSValue(object: searchfunc, in: robj.context), forProperty: KMTableData.SearchItem)

		/* table() */
		addScriptedProperty(object: robj, forProperty: KMTableData.TableItem)
		let tabfunc: @convention(block) () -> JSValue = {
			() -> JSValue in
			if let table = self.mTable {
				let tabobj = KLTable(table: table, context: robj.context)
				return JSValue(object: tabobj, in: robj.context)
			} else {
				return JSValue(nullIn: robj.context)
			}
		}
		robj.setImmediateValue(value: JSValue(object: tabfunc, in: robj.context), forProperty: KMTableData.TableItem)

		/* callback for update event */
		mEventCallbackId = table.allocateEventFunction(eventFunc: {
			() -> Void in
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in self.updateData()
			})
		})
		return nil // no error
	}

	private func updateData() {
		if let table = mTable {
			let robj = super.reactObject

			/* fieldNames */
			let fnames = table.fieldNames.map({ (_ key: String) -> CNValue in return .stringValue(key) })
			robj.setArrayValue(value: fnames, forProperty: KMTableData.FieldNamesItem)

			/* recordCount */
			robj.setNumberValue(value: NSNumber(integerLiteral: table.recordCount), forProperty: KMTableData.RecordCountItem)

			/* update count */
			addScriptedProperty(object: robj, forProperty: KMTableData.UpdateItem)
			robj.setNumberValue(value: NSNumber(integerLiteral: mUpdateCount), forProperty: KMTableData.UpdateItem)
			mUpdateCount += 1
		}
	}
}


*/
