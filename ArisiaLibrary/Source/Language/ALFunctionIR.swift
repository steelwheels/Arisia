/**
 * @file	ALFunctionIR.swift
 * @brief	Define ALFunctionIR class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

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
		public var type:	ALType
		public var name:	String
		public init(type typ: ALType, name nm: String){
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

	public var script:	String { get { return mScript     }}
	public var sourceFile:	URL?   { get { return mSourceFile  }}

	public init(script scr: String, source src: URL?) {
		mScript		= scr
		mSourceFile	= src
	}

	open func toScript() -> String {
		return toScript(arguments: [])
	}

	public func toScript(arguments args: Array<String>) -> String {
		let argstr = args.joined(separator: ", ")
		return    "function(\(argstr)) {\n"
		        + mScript
			+ "}"
	}
}

public class ALInitFunctionIR: ALFunctionIR
{
	public override init(script scr: String, source src: URL?) {
		super.init(script: scr, source: src)
	}

	public override func toScript() -> String {
		return toScript(arguments: ["self"])
	}

	public static func functionBodyName(name nm: String) -> String {
		return "_" + nm + "_ifunc"
	}
}

public class ALEventFunctionIR: ALFunctionIR
{
	private var mArguments: Array<Argument>

	public var arguments: Array<Argument> { get { return mArguments }}

	public init(arguments args: Array<Argument>, script scr: String, source src: URL?) {
		mArguments = args
		super.init(script: scr, source: src)
	}

	public override func toScript() -> String {
		var args: Array<String> = ["self"]
		args.append(contentsOf: mArguments.map { $0.name })
		return toScript(arguments: args)
	}
}

public class ALListnerFunctionIR: ALFunctionIR
{
	private var mArguments:		Array<PathArgument>
	private var mReturnType:	ALType

	public var pathArguments: Array<PathArgument>	{ get { return mArguments }}
	public var returnType: ALType			{ get { return mReturnType }}

	public init(arguments args: Array<PathArgument>, returnType rtype: ALType, script scr: String, source src: URL?) {
		mArguments  = args
		mReturnType = rtype
		super.init(script: scr, source: src)
	}

	public override func toScript() -> String {
		var args: Array<String> = ["self"]
		args.append(contentsOf: mArguments.map { $0.name })
		return toScript(arguments: args)
	}

	public static func functionBodyName(name nm: String) -> String {
		return "_" + nm + "_lfunc"
	}
}

public class ALProceduralFunctionIR: ALFunctionIR
{
	private var mArguments: Array<Argument>
	private var mReturnType:	ALType

	public var arguments: Array<Argument>	{ get { return mArguments }}
	public var returnType: ALType		{ get { return mReturnType }}

	public init(arguments args: Array<Argument>, returnType rtype: ALType, script scr: String, source src: URL?) {
		mArguments	= args
		mReturnType	= rtype
		super.init(script: scr, source: src)
	}

	public override func toScript() -> String {
		let args = mArguments.map { $0.name }
		return toScript(arguments: args)
	}
}


