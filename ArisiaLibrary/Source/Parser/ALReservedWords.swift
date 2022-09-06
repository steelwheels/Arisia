/**
 * @file	ALReservedWords.swift
 * @brief	Define ALReservedWords enum
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import Foundation

public enum ALReservedWord: Int {
	case Boolean
	case Class
	case Event
	case Func
	case Init
	case Listner
	case Number
	case Root
	case String

	static let allWords: Array<ALReservedWord> = [
		.Boolean,
		.Class,
		.Event,
		.Func,
		.Init,
		.Listner,
		.Number,
		.Root,
		.String
	]

	public static func toString(reservedWord rword: ALReservedWord) -> String {
		let result: String
		switch rword {
		case .Boolean:		result = "bool"
		case .Class:		result = "class"
		case .Event:		result = "event"
		case .Func:		result = "func"
		case .Init:		result = "init"
		case .Listner:		result = "listner"
		case .Number:		result = "number"
		case .Root:		result = "root"
		case .String:		result = "string"
		}
		return result
	}

	private static var mTable: Dictionary<String, Int> = [:]

	public static func toTable() -> Dictionary<String, Int> {
		if mTable.count == 0 {
			var newtable: Dictionary<String, Int> = [:]
			for word in ALReservedWord.allWords {
				newtable[ALReservedWord.toString(reservedWord: word)] = word.rawValue
			}
			mTable = newtable
		}
		return mTable
	}

}
