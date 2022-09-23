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
	public typealias AllocatorFunc = (_ ctxt: KEContext) -> ALFrame?

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

	private var mAllocators: Dictionary<String, AllocatorFunc>

	private init(){
		mAllocators = [
			ALConfig.defaultFrameName: {
				(_ ctxt: KEContext) -> ALFrame? in
				return ALDefaultFrame(frameName: ALConfig.defaultFrameName, context: ctxt)
			}
		]
	}

	public func add(className name: String, allocator alloc: @escaping AllocatorFunc){
		mAllocators[name] = alloc
	}

	public func isFrameClassName(name nm: String) -> Bool {
		if let _ = mAllocators[nm] {
			return true
		} else {
			return false
		}
	}

	public func allocateFrame(className name: String, context ctxt: KEContext) -> ALFrame? {
		if let alloc = mAllocators[name] {
			return alloc(ctxt)
		} else {
			return nil
		}
	}
}
