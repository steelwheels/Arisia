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
	private struct Member {
		var name:	String
		var value:	ALFrameIR.Member

		public init(name nm: String, value val: ALFrameIR.Member){
			name 	= nm
			value 	= val
		}
	}

	public func parse(source src: String, sourceFile srcfile: URL?) -> Result<ALFrameIR, NSError> {
		let conf = CNParserConfig(allowIdentiferHasPeriod: false)
		switch CNStringToToken(string: src, config: conf) {
		case .ok(let tokens):
			let ptokens = preprocess(source: tokens)
			let stream  = CNTokenStream(source: ptokens)
			return parseFrame(stream: stream, sourceFile: srcfile)
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

	private func parseFrame(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<ALFrameIR, NSError> {
		guard let ident = strm.getIdentifier() else {
			return .failure(parseError(message: "Identifier is required", stream: strm))
		}
		guard strm.requireSymbol(symbol: ":") else {
			return .failure(parseError(message: "\":\" is required", stream: strm))
		}
		if let clsname = strm.requireIdentifier() {
			switch parseFrame(className: clsname, instanceName: ident, stream: strm, sourceFile: srcfile) {
			case .success(let value):
				return .success(value)
			case .failure(let err):
				return .failure(err)
			}
		} else {
			return .failure(parseError(message: "Component class name is required", stream: strm))
		}
	}

	private func parseFrame(className cname: String, instanceName iname: String, stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<ALFrameIR, NSError> {
		let newframe = ALFrameIR(className: cname, instanceName: iname)
		guard strm.requireSymbol(symbol: "{") else {
			return .failure(parseError(message: "\"{\" is required for \"\(iname)\" component", stream: strm))
		}
		var finished = false
		while !finished {
			if strm.requireSymbol(symbol: "}") {
				finished = true
			} else {
				switch parseMember(stream: strm, sourceFile: srcfile) {
				case .success(let memb):
					if newframe.member(name: memb.name) != nil {
						return .failure(parseError(message: "The member named \"\(memb.name)\" is already defined", stream: strm))
					} else {
						newframe.set(name: memb.name, member: memb.value)
					}
				case .failure(let err):
					return .failure(err)
				}
			}
		}
		return .success(newframe)
	}

	private func parseMember(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<Member, NSError> {
		guard let ident = strm.getIdentifier() else {
			return .failure(parseError(message: "Identifier for frame member is required", stream: strm))
		}
		guard strm.requireSymbol(symbol: ":") else {
			return .failure(parseError(message: "\":\" for frame member is required", stream: strm))
		}
		if let member = strm.requireIdentifier() {
			if let ftype = decodeFunctionType(string: member) {
				switch ftype {
				case .initFunction:
					switch parseInitFunc(stream: strm, sourceFile: srcfile) {
					case .success(let val):
						return .success(Member(name: ident, value: .initFunction(val)))
					case .failure(let err):
						return .failure(err)
					}
				case .eventFunction:
					switch parseEventFunc(stream: strm, sourceFile: srcfile) {
					case .success(let val):
						return .success(Member(name: ident, value: .eventFunction(val)))
					case .failure(let err):
						return .failure(err)
					}
				case .listnerFunction:
					switch parseListnerFunc(stream: strm, sourceFile: srcfile) {
					case .success(let val):
						return .success(Member(name: ident, value: .listnerFunction(val)))
					case .failure(let err):
						return .failure(err)
					}
				case .proceduralFunction:
					switch parseProceduralFunc(stream: strm, sourceFile: srcfile) {
					case .success(let val):
						return .success(Member(name: ident, value: .procedureFunction(val)))
					case .failure(let err):
						return .failure(err)
					}
				default:
					return .failure(parseError(message: "Unexpected function type", stream: strm))
				}
			} else if let etype = CNEnumTable.currentEnumTable().search(byTypeName: member) {
				switch parseEnumValue(enumType: etype, stream: strm) {
				case .success(let val):
					return .success(Member(name: ident, value: .number(val)))
				case .failure(let err):
					return .failure(err)
				}
			} else {
				switch parseFrame(className: member, instanceName: ident, stream: strm, sourceFile: srcfile) {
				case .success(let val):
					return .success(Member(name: ident, value: .frame(val)))
				case .failure(let err):
					return .failure(err)
				}
			}
		} else {
			switch parseValue(stream: strm, sourceFile: srcfile) {
			case .success(let val):
				return .success(Member(name: ident, value: val))
			case .failure(let err):
				return .failure(err)
			}
		}
	}

	private func parseInitFunc(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<ALInitFunctionIR, NSError> {
		if let text = strm.getText() {
			return .success(ALInitFunctionIR(script: text, source: srcfile))
		} else {
			return .failure(parseError(message: "The body of Init function is required", stream: strm))
		}
	}

	private func parseEventFunc(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<ALEventFunctionIR, NSError> {
		guard strm.requireSymbol(symbol: "(") else {
			return .failure(parseError(message: "\"(\" is required to define event function parameters", stream: strm))
		}
		var args: Array<ALFunctionIR.Argument> = []
		var finished = strm.requireSymbol(symbol: ")")
		while !finished {
			switch parseArgument(stream: strm) {
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

	private func parseListnerFunc(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<ALListnerFunctionIR, NSError> {
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
			return .failure(parseError(message: "The body of Event function is required", stream: strm))
		}
	}

	private func parseProceduralFunc(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<ALProceduralFunctionIR, NSError> {
		var args: Array<ALFunctionIR.Argument> = []
		guard strm.requireSymbol(symbol: "(") else {
			return .failure(parseError(message: "\"(\" is required to define procedural function parameters", stream: strm))
		}
		var finished = strm.requireSymbol(symbol: ")")
		while !finished {
			switch parseArgument(stream: strm) {
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
			return .failure(parseError(message: "The body of Event function is required", stream: strm))
		}
	}
	
	private func parseArgument(stream strm: CNTokenStream) -> Result<ALFunctionIR.Argument, NSError> {
		guard let ident = strm.getIdentifier() else {
			return .failure(parseError(message: "Identifier for argument is required", stream: strm))
		}
		guard strm.requireSymbol(symbol: ":") else {
			return .failure(parseError(message: "\":\" after argument name is required", stream: strm))
		}
		switch parseType(stream: strm) {
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

	private func parseEnumValue(enumType etype: CNEnumType, stream strm: CNTokenStream) -> Result<NSNumber, NSError> {
		if strm.requireSymbol(symbol: ".") {
			if let ident = strm.getIdentifier() {
				if let eobj = etype.allocate(name: ident) {
					return .success(NSNumber(integerLiteral: eobj.value))
				} else {
					return .failure(parseError(message: "Unknown enum value \(ident) for enum type \(etype.typeName)", stream: strm))
				}
			} else {
				return .failure(parseError(message: "No enum value identifier", stream: strm))
			}
		} else {
			return .failure(parseError(message: "\".\" is required after enum type", stream: strm))
		}
	}

	private func parseValue(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<ALFrameIR.Member, NSError> {
		if let sym = strm.requireSymbol() {
			switch sym {
			case "[":
				let _ = strm.unget() // unget "["
				switch parseArrayValue(stream: strm, sourceFile: srcfile) {
				case .success(let val):
					return .success(.array(val))
				case .failure(let err):
					return .failure(err)
				}
			case "{":
				let _ = strm.unget() // unget "{"
				switch parseDictionaryValue(stream: strm, sourceFile: srcfile) {
				case .success(let val):
					return .success(.dictionary(val))
				case .failure(let err):
					return .failure(err)
				}
			default:
				return .failure(parseError(message: "Unexpected symbol \"\(sym)\"", stream: strm))
			}
		} else if let funcstr = strm.requireIdentifier() {
			if let functype = decodeFunctionType(string: funcstr) {
				switch functype {
				case .initFunction:
					switch parseInitFunc(stream: strm, sourceFile: srcfile) {
					case .success(let val):
						return .success(.initFunction(val))
					case .failure(let err):
						return .failure(err)
					}
				case .eventFunction:
					switch parseEventFunc(stream: strm, sourceFile: srcfile) {
					case .success(let val):
						return .success(.eventFunction(val))
					case .failure(let err):
						return .failure(err)
					}
				case .listnerFunction:
					switch parseListnerFunc(stream: strm, sourceFile: srcfile) {
					case .success(let val):
						return .success(.listnerFunction(val))
					case .failure(let err):
						return .failure(err)
					}
				case .proceduralFunction:
					switch parseProceduralFunc(stream: strm, sourceFile: srcfile) {
					case .success(let val):
						return .success(.procedureFunction(val))
					case .failure(let err):
						return .failure(err)
					}
				default:
					return .failure(parseError(message: "Unknown function type: \(funcstr)", stream: strm))
				}

			} else if let etype = CNEnumTable.currentEnumTable().search(byTypeName: funcstr) {
				switch parseEnumValue(enumType: etype, stream: strm) {
				case .success(let val):
					return .success(.number(val))
				case .failure(let err):
					return .failure(err)
				}
			} else {
				return .failure(parseError(message: "Unknown function type: \(funcstr)", stream: strm))
			}
		} else {
			switch parseScalarValue(stream: strm) {
			case .success(let val):
				return .success(val)
			case .failure(let err):
				return .failure(err)
			}
		}
	}

	private func parseArrayValue(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<Array<ALFrameIR.Member>, NSError> {
		var result: Array<ALFrameIR.Member> = []
		guard strm.requireSymbol(symbol: "[") else {
			return .failure(parseError(message: "\"[\" for frame member is required", stream: strm))
		}
		var finished = false
		var is1st    = true
		while !finished {
			if strm.requireSymbol(symbol: "]") {
				finished = true
			} else {
				if is1st {
					is1st = false
				} else {
					if !strm.requireSymbol(symbol: ",") {
						return .failure(parseError(message: "\",\" is required between array elements", stream: strm))
					}
				}
				switch parseValue(stream: strm, sourceFile: srcfile) {
				case .success(let val):
					result.append(val)
				case .failure(let err):
					return .failure(err)
				}
			}
		}
		return .success(result)
	}

	private func parseDictionaryValue(stream strm: CNTokenStream, sourceFile srcfile: URL?) -> Result<Dictionary<String, ALFrameIR.Member>, NSError> {
		var result: Dictionary<String, ALFrameIR.Member> = [:]
		guard strm.requireSymbol(symbol: "{") else {
			return .failure(parseError(message: "\"{\" for frame member is required", stream: strm))
		}
		var finished = false
		var is1st    = true
		while !finished {
			if strm.requireSymbol(symbol: "}") {
				finished = true
			} else {
				if is1st {
					is1st = false
				} else {
					if !strm.requireSymbol(symbol: ",") {
						return .failure(parseError(message: "\",\" is required between array elements", stream: strm))
					}
				}
				guard let ident = strm.requireIdentifier() else {
					return .failure(parseError(message: "Identifier as dictionary key is required", stream: strm))
				}
				guard strm.requireSymbol(symbol: ":") else {
					return .failure(parseError(message: "\":\" to divide key and value is required", stream: strm))
				}
				switch parseValue(stream: strm, sourceFile: srcfile) {
				case .success(let val):
					result[ident] = val
				case .failure(let err):
					return .failure(err)
				}
			}
		}
		return .success(result)
	}

	private func parseScalarValue(stream strm: CNTokenStream) -> Result<ALFrameIR.Member, NSError> {
		guard let token = strm.get() else {
			return .failure(parseError(message: "Unexpected end of script", stream: strm))
		}
		switch token.type {
		case .BoolToken(let val):
			return .success(.bool(val))
		case .UIntToken(let val):
			return .success(.number(NSNumber(value: val)))
		case .IntToken(let val):
			return .success(.number(NSNumber(value: val)))
		case .DoubleToken(let val):
			return .success(.number(NSNumber(value: val)))
		case .StringToken(let val):
			return .success(.string(val))
		case .TextToken(let val):
			return .success(.string(val))
		case .IdentifierToken(let ident):
			return .failure(parseError(message: "Unexpected identifier: \(ident)", stream: strm))
		case .SymbolToken(let sym):
			return .failure(parseError(message: "Unexpected symbol: \(sym)", stream: strm))
		case .ReservedWordToken(_), .CommentToken(_):
			return .failure(parseError(message: "Unexpected token: \(token.description)", stream: strm))
		@unknown default:
			return .failure(parseError(message: "Unknown token", stream: strm))
		}
	}

	private func parseType(stream strm: CNTokenStream) -> Result<ALTypeIR, NSError> {
		return ALTypeIR.parse(stream: strm)
	}

	private func decodeFunctionType(string str: String) -> ALTypeIR? {
		switch str {
		case ALInitFunctionIR.TypeName:			return .initFunction
		case ALEventFunctionIR.TypeName:		return .eventFunction
		case ALListnerFunctionIR.TypeName:		return .listnerFunction
		case ALProceduralFunctionIR.TypeName:		return .proceduralFunction
		default:					return nil
		}
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
}

