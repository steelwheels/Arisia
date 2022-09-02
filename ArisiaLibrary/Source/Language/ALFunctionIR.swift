/**
 * @file	ALFunctionIR.swift
 * @brief	Define ALFunctionIR class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import Foundation

public struct ALPathExpressionIR {
	var 	pathElements: Array<String>

	public init(elements elms: Array<String>){
		pathElements = elms
	}
}

open class ALFunctionIR
{
	public struct Argument {
		public var type:	ALTypeIR
		public var name:	String
		public init(type typ: ALTypeIR, name nm: String){
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
}

public class ALInitFunctionIR: ALFunctionIR
{
	public static var TypeName	= "init"

	public override init(script scr: String, source src: URL?) {
		super.init(script: scr, source: src)
	}
}

public class ALEventFunctionIR: ALFunctionIR
{
	public static var TypeName	= "event"

	private var mArguments: Array<Argument>

	public init(arguments args: Array<Argument>, script scr: String, source src: URL?) {
		mArguments = args
		super.init(script: scr, source: src)
	}
}

public class ALListnerFunctionIR: ALFunctionIR
{
	public static var TypeName	= "listner"

	private var mArguments: Array<PathArgument>

	public init(arguments args: Array<PathArgument>, script scr: String, source src: URL?) {
		mArguments = args
		super.init(script: scr, source: src)
	}
}

public class ALProceduralFunctionIR: ALFunctionIR
{
	public static var TypeName	= "func"

	private var mArguments: Array<Argument>
	
	public init(arguments args: Array<Argument>, script scr: String, source src: URL?) {
		mArguments = args
		super.init(script: scr, source: src)
	}
}


