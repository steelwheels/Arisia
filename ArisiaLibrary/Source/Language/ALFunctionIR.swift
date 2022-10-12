/**
 * @file	ALFunctionIR.swift
 * @brief	Define ALFunctionIR class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiLibrary
import CoconutData
import Foundation

public struct ALPathExpressionIR {
	private var mPathElements: Array<String>

	public var pathElements: Array<String> { get { return mPathElements }}

	public init(elements elms: Array<String>){
		mPathElements = elms
	}

	public func description() -> String {
		return mPathElements.joined(separator: ".")
	}

}

public class ALArgument
{
	public var type:	CNValueType
	public var name:	String
	public init(type typ: CNValueType, name nm: String){
		type = typ
		name = nm
	}
}

public class ALPathArgument
{
	public var name:		String
	public var type:		CNValueType?
	public var pathExpression:	ALPathExpressionIR
	public init(name nm: String, pathExpression pexp: ALPathExpressionIR){
		name		= nm
		type		= nil
		pathExpression	= pexp
	}
}

open class ALFunctionIR
{
	private var	mScript		: String
	private var 	mSourceFile	: URL?
	private var	mConfig		: ALConfig

	public var script:	String { get { return mScript     }}
	public var sourceFile:	URL?   { get { return mSourceFile  }}

	public init(script scr: String, source src: URL?, config conf: ALConfig) {
		mScript		= scr
		mSourceFile	= src
		mConfig		= conf
	}

	open func toScript(returnType rettype: CNValueType, language lang: ALLanguage) -> String {
		return toScript(arguments: [], returnType: rettype, language: lang)
	}

	public func toScript(arguments args: Array<ALArgument>, returnType rettype: CNValueType, language lang: ALLanguage) -> String {
		let argelms = args.map { ALFunctionIR.argumentToScript(argument: $0, language: lang)}
		let argstr  = argelms.joined(separator: ", ")

		let retstr: String
		switch lang {
		case .ArisiaScript, .TypeScript:
			retstr = ": " + rettype.toTypeDeclaration()
		case .JavaScript:
			retstr = ""
		}
		return    "function(\(argstr))\(retstr) {\n"
			+ mScript
			+ "}"
	}

	public func toScript(pathArguments paths: Array<ALPathArgument>, returnType rettype: CNValueType, language lang: ALLanguage) -> String {
		var args: Array<String> = []
		for path in paths {
			args.append(ALFunctionIR.pathArgumentToScript(argument: path, language: lang))
		}
		let retstr: String
		switch lang {
		case .ArisiaScript, .TypeScript:
			retstr = ": " + rettype.toTypeDeclaration()
		case .JavaScript:
			retstr = ""
		}
		var stmt = "function(\(args.joined(separator: ", ")))\(retstr) {\n"
		stmt += mScript
		stmt += "}"
		return stmt
	}

	open func toType(framePath path: ALFramePath) -> CNValueType {
		CNLog(logLevel: .error, message: "Do override", atFunction: #function, inFile: #file)
		return .anyType
	}

	public func selfArgument() -> ALArgument {
		let ifname = ALFunctionInterface.defaultInterfaceName(frameName: "Frame")
		return ALArgument(type: .objectType(ifname), name: "self")
	}

	public func selfPathArgument() -> ALPathArgument {
		let exp    = ALPathExpressionIR(elements: ["self"])
		let arg    = ALPathArgument(name: "self", pathExpression: exp)
		let ifname = ALFunctionInterface.defaultInterfaceName(frameName: "Frame")
		arg.type   = .objectType(ifname)

		return arg
	}

	public static func argumentToScript(argument arg: ALArgument, language lang: ALLanguage) -> String {
		let result: String
		switch lang {
		case .JavaScript:
			result = arg.name
		case .TypeScript, .ArisiaScript:
			let tdecl = arg.type.toTypeDeclaration()
			result = arg.name + ": " + tdecl
		}
		return result
	}

	public static func pathArgumentToScript(argument arg: ALPathArgument, language lang: ALLanguage) -> String {
		let result: String
		switch lang {
		case .JavaScript:
			result = arg.name
		case .TypeScript:
			let typestr: String
			if let type = arg.type {
				typestr = type.toTypeDeclaration()
			} else {
				typestr = "any"
			}
			result = arg.name + ": " + typestr
		case .ArisiaScript:
			let elms = arg.pathExpression.pathElements
			result = arg.name + ": " + elms.joined(separator: ".")
		}
		return result
	}
}

public class ALInitFunctionIR: ALFunctionIR
{
	public override init(script scr: String, source src: URL?, config conf: ALConfig) {
		super.init(script: scr, source: src, config: conf)
	}

	public func toScript(language lang: ALLanguage) -> String {
		return super.toScript(arguments: [self.selfArgument()], returnType: .voidType, language: lang)
	}

	public override func toType(framePath path: ALFramePath) -> CNValueType {
		return .functionType(.voidType, [path.selfType])
	}
}

public class ALEventFunctionIR: ALFunctionIR
{
	private var mArguments: Array<ALArgument>

	public var arguments: Array<ALArgument> { get { return mArguments }}

	public init(arguments args: Array<ALArgument>, script scr: String, source src: URL?, config conf: ALConfig) {
		mArguments = args
		super.init(script: scr, source: src, config: conf)
	}

	public func toScript(language lang: ALLanguage) -> String {
		var args: Array<ALArgument> = [self.selfArgument()]
		args.append(contentsOf: mArguments)
		return super.toScript(arguments: args, returnType: .voidType, language: lang)
	}

	public override func toType(framePath path: ALFramePath) -> CNValueType {
		var ptypes: Array<CNValueType> = [ path.selfType ]
		ptypes.append(contentsOf: self.mArguments.map { $0.type })
		return .functionType(.voidType, ptypes)
	}
}

public class ALListnerFunctionIR: ALFunctionIR
{
	private var mArguments:		Array<ALPathArgument>
	private var mReturnType:	CNValueType

	public var pathArguments: 	Array<ALPathArgument>	{ get { return mArguments	}}
	public var returnType:    	CNValueType		{ get { return mReturnType	}}

	public init(arguments args: Array<ALPathArgument>, returnType rtype: CNValueType, script scr: String, source src: URL?, config conf: ALConfig) {
		mArguments	= args
		mReturnType	= rtype
		super.init(script: scr, source: src, config: conf)
	}

	public func toScript(language lang: ALLanguage) -> String {
		let selfarg  = self.selfPathArgument()

		var args: Array<ALPathArgument> = [ selfarg ]
		args.append(contentsOf: mArguments)

		return super.toScript(pathArguments: args, returnType: mReturnType, language: lang)
	}

	public override func toType(framePath path: ALFramePath) -> CNValueType {
		var ptypes: Array<CNValueType> = [ path.selfType ]
		ptypes.append(contentsOf: mArguments.map {
			if let type = $0.type { return type } else { return .anyType}
		})
		return .functionType(.voidType, ptypes)
	}

	public static func makeFullPathFuncName(path pth: Array<String>, propertyName pname: String) -> String {
		var result: String
		if pth.count > 0 {
			result = "_lfunc_" + pth.joined(separator: "_") + "_" + pname
		} else {
			result = "_lfunc_" + pname
		}
		return result
	}
}

public class ALProceduralFunctionIR: ALFunctionIR
{
	private var mArguments:		Array<ALArgument>
	private var mReturnType:	CNValueType

	public var arguments:  Array<ALArgument>	{ get { return mArguments }}
	public var returnType: CNValueType		{ get { return mReturnType }}

	public init(arguments args: Array<ALArgument>, returnType rtype: CNValueType, script scr: String, source src: URL?, config conf: ALConfig) {
		mArguments	= args
		mReturnType	= rtype
		super.init(script: scr, source: src, config: conf)
	}

	public func toScript(language lang: ALLanguage) -> String {
		return super.toScript(arguments: mArguments, returnType: mReturnType, language: lang)
	}

	public override func toType(framePath path: ALFramePath) -> CNValueType {
		let ptypes = mArguments.map { return $0.type }
		return .functionType(.voidType, ptypes)
	}
}

public class ALImmediatelyInvokedFunctionIR: ALFunctionIR
{
	private var mReturnType:	CNValueType

	public init(returnType rtype: CNValueType, script scr: String, source src: URL?, config conf: ALConfig) {
		mReturnType = rtype
		super.init(script: scr, source: src, config: conf)
	}

	/* IIFE: Immediately Invoked function expression
	 *    (function() {
	 *       console.log(`Hi, I'm ${name}.`);
	 *    })();
	 */
	public func toScript(language lang: ALLanguage) -> String {
		let head = "(function() {\n"
		let tail = "\n})()"
		return head + self.script + tail
	}

	public override func toType(framePath path: ALFramePath) -> CNValueType {
		return mReturnType
	}
}

