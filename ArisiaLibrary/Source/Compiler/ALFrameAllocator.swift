/**
 * @file	ALFrameAllocatorr.swift
 * @brief	Define ALFrameAllocator class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import KiwiEngine
import CoconutData
import Foundation

public class ALFrameAllocator
{
	public struct Allocator {
		public var frameName:		String
		public var allocFuncBody:	(_ ctxt: KEContext) -> ALFrame?
		public var propertyTypes:	Dictionary<String, CNValueType>

		public init(frameName name: String, allocFuncBody body: @escaping (_ ctxt: KEContext) -> ALFrame?, propertyTypes ptypes: Dictionary<String, CNValueType>){
			frameName	= name
			allocFuncBody	= body
			propertyTypes	= ptypes
		}

		public func allocFunctionName() -> String {
			return "_alloc_" + frameName
		}
	}

	private static var mSharedAllocator: ALFrameAllocator? = nil

	public static var shared: ALFrameAllocator { get {
		if let alloc = mSharedAllocator {
			return alloc
		} else {
			let newalloc = ALFrameAllocator()
			mSharedAllocator = newalloc
			return newalloc
		}
	}}

	private var mAllocators: Dictionary<String, Allocator>

	private init(){
		let defname = ALDefaultFrame.FrameName
		let defalloc = Allocator(frameName: defname, allocFuncBody: {
			(_ ctxt: KEContext) -> ALFrame? in
			return ALDefaultFrame(frameName: defname, context: ctxt)
		}, propertyTypes: ALDefaultFrame.propertyTypes)
		mAllocators = [defname: defalloc]
	}

	public var classNames: Array<String> { get { return Array(mAllocators.keys.sorted()) }}

	public func add(className name: String, allocator alloc: Allocator){
		mAllocators[name] = alloc
	}

	public func search(byClassName name: String) -> Allocator? {
		return mAllocators[name]
	}

	public func isFrameClassName(name nm: String) -> Bool {
		if let _ = mAllocators[nm] {
			return true
		} else {
			return false
		}
	}
}
