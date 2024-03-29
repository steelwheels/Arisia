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
	private static let IndexItem		= "index"
	private static let NewRecordItem	= "newRecord"
	private static let SearchItem		= "search"
	private static let RecordItem		= "record"
	private static let TableItem		= "table"
	private static let UpdateItem		= "update"

	private var mContext:		KEContext
	private var mFrameCore:		ALFrameCore
	private var mPath:		ALFramePath
	private var mTable: 		CNStorageTable?
	private var mIndex:		Int

	public var core: ALFrameCore { get { return mFrameCore }}
	public var path: ALFramePath { get { return mPath 	}}

	public init(context ctxt: KEContext){
		mContext	= ctxt
		mFrameCore	= ALFrameCore(frameName: AMTableData.ClassName, context: ctxt)
		mPath 		= ALFramePath()
		mTable		= nil
		mIndex		= 0

		mFrameCore.owner = self
	}

	static public var interfaceType: CNInterfaceType { get {
		let ifname = ALFunctionInterface.defaultInterfaceName(frameName: AMTableData.ClassName)
		if let iftype = CNInterfaceTable.currentInterfaceTable().search(byTypeName: ifname) {
			return iftype
		} else {
			let baseif = ALDefaultFrame.interfaceType
			let recif: CNInterfaceType
			if let ifval = CNInterfaceTable.currentInterfaceTable().search(byTypeName: "RecordIF") {
				recif = ifval
			} else {
				CNLog(logLevel: .error, message: "InterfaceType RecordIF is not found")
				recif = CNInterfaceType(name: "RecordIF", base: nil, types: [:])
			}
			let ptypes: Dictionary<String, CNValueType> = [
				AMTableData.StorageItem:	.stringType,
				AMTableData.PathItem:		.stringType,
				AMTableData.IndexItem:		.numberType,
				AMTableData.CountItem:		.numberType,
				AMTableData.FieldNamesItem:	.arrayType(.stringType),
				AMTableData.FieldNameItem:	.functionType(.stringType, []),
				AMTableData.NewRecordItem:	.interfaceType(recif),
				AMTableData.RecordItem:		.interfaceType(recif)
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
		defineInterfaceType(interfaceType: AMTableData.interfaceType)

		/* Set default properties */
		self.setupDefaulrProperties()

		/* storage */
		let storagename: String?
		if let name = stringValue(name: AMTableData.StorageItem) {
			storagename = name
		} else {
			setStringValue(name: AMTableData.StorageItem, value: "<no-storage-name>")
			storagename = nil
		}

		/* path */
		let pathname: String?
		if let name = stringValue(name: AMTableData.PathItem) {
			pathname = name
		} else {
			setStringValue(name: AMTableData.PathItem, value: "<no-path-name>")
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
		mTable = table

		/* index */
		if let idxnum = numberValue(name: AMTableData.IndexItem) {
			mIndex = idxnum.intValue
		} else {
			setNumberValue(name: AMTableData.IndexItem, value: NSNumber(integerLiteral: mIndex))
		}
		addObserver(propertyName: AMTableData.IndexItem, listnerFunction: {
			(_ param: JSValue) -> Void in
			if let num = param.toNumber() {
				self.mIndex = num.intValue
				self.updateRecordValue(table: table)
			} else {
				CNLog(logLevel: .error, message: "Invalid type for new index")
			}
		})

		/* fieldName(index: number): string */
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
		let recname = recordIF(storageName: storagename, pathName: pathname)
		let recif   = CNInterfaceType(name: recname, base: nil, types: [:])
		definePropertyType(propertyName: AMTableData.NewRecordItem, valueType: .interfaceType(recif))
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

		/* record: KLRecord (read only) */
		definePropertyType(propertyName: AMTableData.RecordItem, valueType: .interfaceType(recif))
		let recfunc: @convention(block) (_ idxval: JSValue) -> JSValue = {
			(_ idxval: JSValue) -> JSValue in
			if let idxnum = idxval.toNumber() {
				let idx = idxnum.intValue
				if let rec = table.record(at: idx) {
					let recobj = KLRecord(record: rec, context: self.core.context)
					if let val = KLRecord.allocate(record: recobj) {
						return val
					} else {
						return JSValue(nullIn: self.core.context)
					}
				}
			}
			CNLog(logLevel: .error, message: "Invalid parameter for record method", atFunction: #function, inFile: #file)
			return JSValue(nullIn: self.core.context)
		}
		if let funcval = JSValue(object: recfunc, in: core.context) {
			setValue(name: AMTableData.RecordItem, value: funcval)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate function", atFunction: #function, inFile: #file)
		}

		/* Update read-only properties */
		updateTablePropeties(table: table)
		updateRecordValue(table: table)

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
			CNLog(logLevel: .error, message: "Failed to load table for TableData component: \(AMTableData.StorageItem) = \(sname), \(AMTableData.PathItem) = \(pname)")
			return nil
		}
	}

	private func recordIF(storageName snamep: String?, pathName pnamep: String?) -> String {
		let UnknownIF = "RecordIF"
		guard let sname = snamep, let pname = pnamep else {
			return UnknownIF
		}
		switch CNValuePath.pathExpression(string: pname) {
		case .success(let path):
			return ALTypeDeclGenerator.pathToRecordIF(storageName: sname, path: path)
		case .failure(let err):
			CNLog(logLevel: .error, message: "\(err.toString())", atFunction: #function, inFile: #file)
			return UnknownIF
		}
	}

	private func updateRecordValue(table tbl: CNStorageTable) {
		if let rec = tbl.record(at: mIndex) {
			let recobj = KLRecord(record: rec, context: self.core.context)
			if let val = KLRecord.allocate(record: recobj) {
				setObjectValue(name: AMTableData.RecordItem, value: val)
			} else {
				setValue(name: AMTableData.RecordItem, value: JSValue(nullIn: self.core.context))
			}
		} else {
			setValue(name: AMTableData.RecordItem, value: JSValue(nullIn: self.core.context))
		}
	}

	private func updateTablePropeties(table tbl: CNStorageTable) {
		/* count */
		setNumberValue(name: AMTableData.CountItem, value: NSNumber(value: tbl.recordCount))

		/* fieldNames */
		if let fnames = JSValue(object: tbl.fieldNames, in: core.context) {
			setValue(name: AMTableData.FieldNamesItem, value: fnames)
		} else {
			CNLog(logLevel: .error, message: "Failed to allocate array", atFunction: #function, inFile: #file)
		}
	}
}
