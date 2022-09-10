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

	public static func identifierToReservedWord(identifier ident: String) -> ALReservedWord? {
		let result: ALReservedWord?
		switch ident {
		case "boolean":	result = .Boolean
		case "class":	result = .Class
		case "event":	result = .Event
		case "func":	result = .Func
		case "init":	result = .Init
		case "listner":	result = .Listner
		case "number":	result = .Number
		case "root":	result = .Root
		case "string":	result = .String
		default:	result = nil
		}
		return result
	}

	public static func toString(reservedWord rword: ALReservedWord) -> String {
		let result: String
		switch rword {
		case .Boolean:		result = "boolean"
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
}


