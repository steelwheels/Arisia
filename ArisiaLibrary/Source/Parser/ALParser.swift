/**
 * @file	ALParser.swift
 * @brief	Define ALParser class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
import Foundation

/*
 * Parse the source string and generate the Arisia IR
 */
public class ALParser
{
	public func parse(source src: String, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALFrameIR, NSError> {
		let conf = CNParserConfig(allowIdentiferHasPeriod: false)
		switch CNStringToToken(string: src, config: conf) {
		case .ok(let tokens):
			let ptokens = preprocess(source: tokens)
			let stream  = CNTokenStream(source: ptokens)
			return parseFrame(className: "Frame", stream: stream, sourceFile: srcfile, frameTable: ftable)
		case .error(let err):
			return .failure(err)
		@unknown default:
			return .failure(NSError.unknownError())
		}
	}

	/*
	 * - Replace "\\n" by "\n"
	 * - Concatenate continual strings into one string
	 */
	private func preprocess(source srcs: Array<CNToken>) -> Array<CNToken> {
		let tokens0 = preprocessNewlines(source: srcs)
		let tokens1 = preprocessReservedWords(source: tokens0)
		return tokens1
	}

	private func preprocessNewlines(source srcs: Array<CNToken>) -> Array<CNToken> {
		var result:  Array<CNToken> = []
		var prevstr:  String?       = nil
		var prevline: Int           = 0
		for src in srcs {
			switch src.type {
			case .StringToken(let str):
				/* Replace "\n" by new line*/
				let mstr = str.replacingOccurrences(of: "\\n", with: "\n")
				/* Keep the current string in token to connect with the next string token */
				if let pstr = prevstr {
					prevstr  = pstr + mstr
				} else {
					prevstr  = mstr
					prevline = src.lineNo
				}
			default:
				/* Flush the kept string */
				if let pstr = prevstr {
					result.append(CNToken(type: .StringToken(pstr), lineNo: prevline))
					prevstr = nil
				}
				result.append(src)
			}
		}
		return result
	}

	private func preprocessReservedWords(source srcs: Array<CNToken>) -> Array<CNToken> {
		var result:  Array<CNToken> = []
		for src in srcs {
			switch src.type {
			case .IdentifierToken(let ident):
				if let rword = ALReservedWord.identifierToReservedWord(identifier: ident) {
					result.append(CNToken(type: .ReservedWordToken(rword.rawValue), lineNo: src.lineNo))
				} else {
					result.append(src)
				}
			default:
				result.append(src)
			}
		}
		return result
	}

	private func parseFrame(className clsname: String, stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALFrameIR, NSError> {
		guard strm.requireSymbol(symbol: "{") else {
			return .failure(parseError(message: "Initial \"{\" is required", stream: strm))
		}
		let frame = ALFrameIR(className: clsname)
		while true {
			if strm.isEmpty() {
				return .failure(parseError(message: "Last \"}\" is required", stream: strm))
			} else if strm.requireSymbol(symbol: "}") {
				break
			}
			switch parseProperty(stream: strm, sourceFile: srcfile, frameTable: ftable) {
			case .success(let prop):
				frame.set(property: prop)
			case .failure(let err):
				return .failure(err)
			}
		}
		if strm.isEmpty() {
			return .success(frame)
		} else {
			return .failure(parseError(message: "Unexpected declaration after last \"}\"", stream: strm))
		}
	}

	private func parseProperty(stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALFrameIR.Property, NSError> {
		guard let ident = strm.getIdentifier() else {
			return .failure(parseError(message: "Identifier is required", stream: strm))
		}
		guard strm.requireSymbol(symbol: ":") else {
			return .failure(parseError(message: "\":\" is required", stream: strm))
		}
		switch parsePropertyValue(stream: strm, sourceFile: srcfile, frameTable: ftable){
		case .success(let val):
			let prop = ALFrameIR.Property(name: ident, value: val)
			return .success(prop)
		case .failure(let err):
			return .failure(err)
		}
	}

	private func parsePropertyValue(stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALValueIR, NSError> {
		if let rword = requireReservedWord(stream: strm) {
			switch rword {
			case .Init:
				switch parseInitFunc(stream: strm, sourceFile: srcfile) {
				case .success(let val):
					return .success(.initFunction(val))
				case .failure(let err):
					return .failure(err)
				}
			case .Event:
				switch parseEventFunc(stream: strm, sourceFile: srcfile, frameTable: ftable) {
				case .success(let val):
					return .success(.eventFunction(val))
				case .failure(let err):
					return .failure(err)
				}
			default:
				let _ = strm.unget() // pushback reserved word
			}
		}
		switch parseType(stream: strm, sourceFile: srcfile, frameTable: ftable){
		case .success(let type):
			switch parseValue(valueType: type, stream: strm, sourceFile: srcfile, frameTable: ftable){
			case .success(let val):
				return .success(val)
			case .failure(let err):
				return .failure(err)
			}
		case .failure(let err):
			return .failure(err)
		}
	}

	private func parseInitFunc(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<ALInitFunctionIR, NSError> {
		if let text = strm.getText() {
			return .success(ALInitFunctionIR(script: text, source: srcfile))
		} else {
			return .failure(parseError(message: "The body of Init function is required", stream: strm))
		}
	}

	private func parseEventFunc(stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALEventFunctionIR, NSError> {
		guard strm.requireSymbol(symbol: "(") else {
			return .failure(parseError(message: "\"(\" is required to define event function parameters", stream: strm))
		}
		var args: Array<ALFunctionIR.Argument> = []
		var finished = strm.requireSymbol(symbol: ")")
		while !finished {
			switch parseArgument(stream: strm, sourceFile: srcfile, frameTable: ftable) {
			case .success(let arg):
				args.append(arg)
				finished = strm.requireSymbol(symbol: ")")
				if !finished {
					guard strm.requireSymbol(symbol: ",") else {
						return .failure(parseError(message: "\",\" is required to list arguments", stream: strm))
					}
					finished = strm.requireSymbol(symbol: ")")
				}
			case .failure(let err):
				return .failure(err)
			}
		}
		if let text = strm.getText() {
			return .success(ALEventFunctionIR(arguments: args, script: text, source: srcfile))
		} else {
			return .failure(parseError(message: "The body of Event function is required", stream: strm))
		}
	}

	private func parseListnerFunc(stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALListnerFunctionIR, NSError> {
		guard strm.requireSymbol(symbol: "(") else {
			return .failure(parseError(message: "\"(\" is required to define listner function parameters", stream: strm))
		}
		var args: Array<ALFunctionIR.PathArgument> = []
		var finished = strm.requireSymbol(symbol: ")")
		while !finished {
			switch parsePathArgument(stream: strm) {
			case .success(let arg):
				args.append(arg)
				finished = strm.requireSymbol(symbol: ")")
				if !finished {
					guard strm.requireSymbol(symbol: ",") else {
						return .failure(parseError(message: "\",\" is required to list arguments", stream: strm))
					}
					finished = strm.requireSymbol(symbol: ")")
				}
			case .failure(let err):
				return .failure(err)
			}
		}
		if let text = strm.getText() {
			return .success(ALListnerFunctionIR(arguments: args, script: text, source: srcfile))
		} else {
			return .failure(parseError(message: "The body of prcedural function is required", stream: strm))
		}
	}

	private func parseProceduralFunc(stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALProceduralFunctionIR, NSError> {
		guard strm.requireSymbol(symbol: "(") else {
			return .failure(parseError(message: "\"(\" is required to define procedural function parameters", stream: strm))
		}
		var args: Array<ALFunctionIR.Argument> = []
		var finished = strm.requireSymbol(symbol: ")")
		while !finished {
			switch parseArgument(stream: strm, sourceFile: srcfile, frameTable: ftable) {
			case .success(let arg):
				args.append(arg)
				finished = strm.requireSymbol(symbol: ")")
				if !finished {
					guard strm.requireSymbol(symbol: ",") else {
						return .failure(parseError(message: "\",\" is required to list arguments", stream: strm))
					}
					finished = strm.requireSymbol(symbol: ")")
				}
			case .failure(let err):
				return .failure(err)
			}
		}
		if let text = strm.getText() {
			return .success(ALProceduralFunctionIR(arguments: args, script: text, source: srcfile))
		} else {
			return .failure(parseError(message: "The body of prcedural function is required", stream: strm))
		}
	}

	private func parseArgument(stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALFunctionIR.Argument, NSError> {
		guard let ident = strm.getIdentifier() else {
			return .failure(parseError(message: "Identifier for argument is required", stream: strm))
		}
		guard strm.requireSymbol(symbol: ":") else {
			return .failure(parseError(message: "\":\" after argument name is required", stream: strm))
		}
		switch parseType(stream: strm, sourceFile: srcfile, frameTable: ftable) {
		case .success(let type):
			return .success(ALFunctionIR.Argument(type: type, name: ident))
		case .failure(let err):
			return .failure(err)
		}
	}

	private func parsePathArgument(stream strm: CNTokenStream) -> Result<ALFunctionIR.PathArgument, NSError> {
		guard let ident = strm.getIdentifier() else {
			return .failure(parseError(message: "Identifier for argument is required", stream: strm))
		}
		guard strm.requireSymbol(symbol: ":") else {
			return .failure(parseError(message: "\":\" after argument name is required", stream: strm))
		}
		switch parsePathExpression(stream: strm) {
		case .success(let pexp):
			return .success(ALFunctionIR.PathArgument(name: ident, pathExpression: pexp))
		case .failure(let err):
			return .failure(err)
		}
	}

	private func parsePathExpression(stream strm: CNTokenStream) -> Result<ALPathExpressionIR, NSError> {
		var elms: Array<String> = []
		var docont  = true
		var require = false
		while docont {
			if let ident = strm.requireIdentifier() {
				elms.append(ident)
				if strm.requireSymbol(symbol: ".") {
					require = true
				} else {
					docont  = false
				}
			} else {
				if require {
					return .failure(parseError(message: "path is required after `.`", stream: strm))
				}
				docont = false
			}
		}
		if elms.count > 0 {
			return .success(ALPathExpressionIR(elements: elms))
		} else {
			return .failure(parseError(message: "No path expression", stream: strm))
		}
	}

	private func parseType(stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALTypeIR, NSError> {
		switch parseElementType(stream: strm, sourceFile: srcfile, frameTable: ftable) {
		case .success(let type):
			if strm.requireSymbol(symbol: "[") {
				if strm.requireSymbol(symbol: "]") {
					return .success(.array(type))
				} else {
					return .failure(parseError(message: "The symbol \"]\" is not exit for the array type declaration", stream: strm))
				}
			} else {
				return .success(type)
			}
		case .failure(let err):
			return .failure(err)
		}
	}

	private func parseElementType(stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALTypeIR, NSError> {
		if let rword = requireReservedWord(stream: strm) {
			let result: ALTypeIR
			switch rword {
			case .Boolean:	result = .bool
			case .Number:	result = .number
			case .String:	result = .string
			case .Class, .Event, .Func, .Init, .Listner, .Root:
				let str = ALReservedWord.toString(reservedWord: rword)
				return .failure(parseError(message: "Unexpected token \(str) for type declaration", stream: strm))
			}
			return .success(result)
		} else if let ident = strm.requireIdentifier() {
			/* Decode as enum */
			let etable = CNEnumTable.currentEnumTable()
			if let etype = etable.search(byTypeName: ident) {
				return .success(.enumType(etype))
			}
			/* Decode as frame */
			if let _ = ftable.search(byName: ident) {
				return .success(.frame(ident))
			}
		} else if strm.requireSymbol(symbol: "[") {
			/* Decode as dictionary
			 * "[" + "name" + ":" + "string" + "]" + ":" + type
			 */
			if hasDictionaryType(stream: strm, sourceFile: srcfile) {
				switch parseType(stream: strm, sourceFile: srcfile, frameTable: ftable){
				case .success(let elmtype):
					return .success(.dictionary(elmtype))
				case .failure(let err):
					return .failure(err)
				}
			}
		}
		return .failure(parseError(message: "Type declaration is required", stream: strm))
	}

	private func hasDictionaryType(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Bool {
		/* Decode as dictionary
		 * "[" + "name" + ":" + "string" + "]" + ":" + type
		 */
		if let _ = strm.requireIdentifier() { // name
			if strm.requireSymbol(symbol: ":") { // :
				if let _ = strm.requireReservedWord() { // string
					if strm.requireSymbol(symbol: "]") { // ]
						if strm.requireSymbol(symbol: ":") { //
							return true
						}
					}
				}
			}
		}
		return false
	}

	private func parseValue(valueType vtype: ALTypeIR, stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALValueIR, NSError> {
		if let rword = requireReservedWord(stream: strm) {
			switch rword {
			case .Listner:
				switch parseListnerFunc(stream: strm, sourceFile: srcfile, frameTable: ftable) {
				case .success(let val):
					return .success(.listnerFunction(val))
				case .failure(let err):
					return .failure(err)
				}
			case .Func:
				switch parseProceduralFunc(stream: strm, sourceFile: srcfile, frameTable: ftable) {
				case .success(let val):
					return .success(.proceduralFunction(val))
				case .failure(let err):
					return .failure(err)
				}
			default:
				let _ = strm.unget()
				break ; // Do nothing
			}
		}
		switch vtype {
		case .bool:
			if let val = strm.requireBool() {
				return .success(.bool(val))
			} else {
				return .failure(parseError(message: "Boolean value is required but not given", stream: strm))
			}
		case .number:
			if let val = strm.requireNumber() {
				return .success(.number(val))
			} else {
				return .failure(parseError(message: "Number value is required but not given", stream: strm))
			}
		case .string:
			if let val = strm.requireString() {
				return .success(.string(val))
			} else {
				return .failure(parseError(message: "String value is required but not given", stream: strm))
			}
		case .frame(let clsname):
			switch parseFrame(className: clsname, stream: strm, sourceFile: srcfile, frameTable: ftable) {
			case .success(let frame):
				return .success(.frame(frame))
			case .failure(let err):
				return .failure(err)
			}
		case .array(let elmtype):
			switch parseArrayValue(elementType: elmtype, stream: strm, sourceFile: srcfile, frameTable: ftable) {
			case .success(let elms):
				return .success(.array(elms))
			case .failure(let err):
				return .failure(err)
			}
		case .dictionary(let elmtype):
			switch parseDictionaryValue(elementType: elmtype, stream: strm, sourceFile: srcfile, frameTable: ftable) {
			case .success(let elms):
				return .success(.dictionary(elms))
			case .failure(let err):
				return .failure(err)
			}
		case .enumType(let etype):
			switch parseEnumValue(enumType: etype, stream: strm, sourceFile: srcfile, frameTable: ftable) {
			case .success(let eval):
				return .success(eval)
			case .failure(let err):
				return .failure(err)
			}
		case .initFunction, .eventFunction, .listnerFunction, .proceduralFunction:
			return .failure(parseError(message: "Internal error in parseValue method", stream: strm))
		}
	}

	private func parseArrayValue(elementType etype: ALTypeIR, stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<Array<ALValueIR>, NSError> {
		var result: Array<ALValueIR> = []
		guard strm.requireSymbol(symbol: "[") else {
			return .failure(parseError(message: "'[' is required for array value", stream: strm))
		}
		var is1st:  Bool = true
		while true {
			if strm.requireSymbol(symbol: "]") {
				break
			}
			if is1st {
				is1st = false
			} else {
				if !strm.requireSymbol(symbol: ",") {
					return .failure(parseError(message: "',' is required between array elements", stream: strm))
				}
			}
			switch parseValue(valueType: etype, stream: strm, sourceFile: srcfile, frameTable: ftable) {
			case .success(let val):
				result.append(val)
			case .failure(let err):
				return .failure(err)
			}
		}
		return .success(result)
	}

	private func parseDictionaryValue(elementType etype: ALTypeIR, stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<Dictionary<String, ALValueIR>, NSError> {
		var result: Dictionary<String, ALValueIR> = [:]
		guard strm.requireSymbol(symbol: "{") else {
			return .failure(parseError(message: "'{' is required for dictionary value", stream: strm))
		}
		var is1st:  Bool = true
		while true {
			if strm.requireSymbol(symbol: "}") {
				break
			}
			if is1st {
				is1st = false
			} else {
				if !strm.requireSymbol(symbol: ",") {
					return .failure(parseError(message: "',' is required between dictionary elements", stream: strm))
				}
			}
			if let key = strm.requireIdentifier() {
				if strm.requireSymbol(symbol: ":") {
					switch parseValue(valueType: etype, stream: strm, sourceFile: srcfile, frameTable: ftable) {
					case .success(let val):
						result[key] = val
					case .failure(let err):
						return .failure(err)
					}
				} else {
					return .failure(parseError(message: "':' is required in dictionary elements", stream: strm))
				}
			} else {
				return .failure(parseError(message: "identifier is required as dictionary key", stream: strm))
			}
		}
		return .success(result)
	}

	private func parseEnumValue(enumType etype: CNEnumType, stream strm: CNTokenStream, sourceFile srcfile: URL?, frameTable ftable: ALFrameTable) -> Result<ALValueIR, NSError> {
		if let ident = strm.requireIdentifier() {
			if let val = etype.value(forMember: ident) {
				return .success(.enumValue(etype, ident, val))
			} else {
				return .failure(parseError(message: "identifier \"\(ident)\" is not enum value", stream: strm))
			}
		} else {
			return .failure(parseError(message: "identifier for enum value is required", stream: strm))
		}
	}

	private func requireReservedWord(stream strm: CNTokenStream) -> ALReservedWord? {
		if let rid = strm.requireReservedWord() {
			if let rword = ALReservedWord(rawValue: rid) {
				return rword
			}
		}
		return nil
	}

	private func parseError(message msg: String, stream strm: CNTokenStream?) -> NSError {
		let lineinfo = makeLineInfo(stream: strm)
		let nearinfo = makeNearInfo(stream: strm)
		return NSError.parseError(message: msg + " " + nearinfo + lineinfo)
	}

	private func makeNearInfo(stream strm: CNTokenStream?) -> String {
		var nearinfo: String = ""
		if let stm = strm {
			if let token = stm.get() {
				nearinfo = "near token \(token.description) "
			}
		}
		return nearinfo
	}

	private func makeLineInfo(stream strm: CNTokenStream?) -> String {
		var lineinfo: String = ""
		if let stm = strm {
			if let lineno = stm.lineNo {
				lineinfo = " at line \(lineno) "
			}
		}
		return lineinfo
	}

	private func dumpTokens(stream strm: CNTokenStream) {
		var index = 0 ;
		while let tkn = strm.peek(offset: index) {
			CNLog(logLevel: .error, message: "tkn\(index): \(tkn.description)")
			index += 1
		}
	}
}

