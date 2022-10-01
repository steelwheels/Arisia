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
}

open class ALFunctionIR
{
	public struct Argument {
		public var type:	CNValueType
		public var name:	String
		public init(type typ: CNValueType, name nm: String){
			type = typ
			name = nm
		}
	}

	public struct PathArgument {
		public var name:		String
		public var pathExpression:	ALPathExpressionIR
		public init(name nm: String, pathExpression pexp: ALPathExpressionIR){
			name		= nm
			pathExpression	= pexp
		}
	}

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

	open func toScript(language lang: ALLanguage) -> String {
		return toScript(arguments: [], language: lang)
	}

	public func selfArgument() -> Argument {
		return Argument(type: .objectType(mConfig.frameInterfaceForScript), name: "self")
	}

	public func selfPathArgument() -> PathArgument {
		let selfexp = ALPathExpressionIR(elements: ["self"])
		return PathArgument(name: "self", pathExpression: selfexp)
	}

	public func toScript(arguments args: Array<Argument>, language lang: ALLanguage) -> String {
		let argelms = args.map { ALFunctionIR.argumentToScript(argument: $0, language: lang)}
		let argstr  = argelms.joined(separator: ", ")
		return    "function(\(argstr)) {\n"
			+ mScript
			+ "}"
	}

	public func toScript(pathArguments args: Array<PathArgument>, language lang: ALLanguage) -> String {
		let argelms = args.map { ALFunctionIR.pathArgumentToScript(argument: $0, language: lang)}
		let argstr  = argelms.joined(separator: ", ")
		return    "function(\(argstr)) {\n"
			+ mScript
			+ "}"
	}

	public static func argumentToScript(argument arg: Argument, language lang: ALLanguage) -> String {
		let result: String
		switch lang {
		case .JavaScript:
			result = arg.name
		case .TypeScript, .ArisiaScript:
			let tdecl = CNValueType.convertToTypeDeclaration(valueType: arg.type)
			result = arg.name + ": " + tdecl
		}
		return result
	}

	public static func pathArgumentToScript(argument arg: PathArgument, language lang: ALLanguage) -> String {
		let result: String
		switch lang {
		case .JavaScript:
			result = arg.name
		case .TypeScript:
			result = arg.name + ": any"
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

	public override func toScript(language lang: ALLanguage) -> String {
		return super.toScript(arguments: [self.selfArgument()], language: lang)
	}

	public static func functionBodyName(name nm: String) -> String {
		return "_" + nm + "_ifunc"
	}
}

public class ALEventFunctionIR: ALFunctionIR
{
	private var mArguments: Array<Argument>

	public var arguments: Array<Argument> { get { return mArguments }}

	public init(arguments args: Array<Argument>, script scr: String, source src: URL?, config conf: ALConfig) {
		mArguments = args
		super.init(script: scr, source: src, config: conf)
	}

	public override func toScript(language lang: ALLanguage) -> String {
		var args: Array<Argument> = [self.selfArgument()]
		args.append(contentsOf: mArguments)
		return super.toScript(arguments: args, language: lang)
	}
}

public class ALListnerFunctionIR: ALFunctionIR
{
	private var mArguments:		Array<PathArgument>
	private var mReturnType:	CNValueType

	public var pathArguments: Array<PathArgument>	{ get { return mArguments }}
	public var returnType:    CNValueType		{ get { return mReturnType }}

	public init(arguments args: Array<PathArgument>, returnType rtype: CNValueType, script scr: String, source src: URL?, config conf: ALConfig) {
		mArguments  = args
		mReturnType = rtype
		super.init(script: scr, source: src, config: conf)
	}

	public override func toScript(language lang: ALLanguage) -> String {
		var args: Array<PathArgument> = [ self.selfPathArgument() ]
		args.append(contentsOf: mArguments)
		return super.toScript(pathArguments: args, language: lang)
	}

	public static func functionBodyName(name nm: String) -> String {
		return "_" + nm + "_lfunc"
	}
}

public class ALProceduralFunctionIR: ALFunctionIR
{
	private var mArguments:		Array<Argument>
	private var mReturnType:	CNValueType

	public var arguments:  Array<Argument>	{ get { return mArguments }}
	public var returnType: CNValueType	{ get { return mReturnType }}

	public init(arguments args: Array<Argument>, returnType rtype: CNValueType, script scr: String, source src: URL?, config conf: ALConfig) {
		mArguments	= args
		mReturnType	= rtype
		super.init(script: scr, source: src, config: conf)
	}

	public override func toScript(language lang: ALLanguage) -> String {
		return super.toScript(arguments: mArguments, language: lang)
	}
}


