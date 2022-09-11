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
	public typealias AllocatorFunc = (_ name: String, _ ctxt: KEContext) -> ALFrameCore?

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

	private var mAllocators: Array<AllocatorFunc> = []

	private init(){
		mAllocators = []
	}

	public func add(allocator alloc: @escaping AllocatorFunc){
		mAllocators.append(alloc)
	}

	public func isFameClassName(name nm: String) -> Bool {
		if nm == "Frame" {
			return true
		} else {
			return false
		}
	}

	public func allocateFrame(className name: String, context ctxt: KEContext) -> ALFrameCore? {
		for allocator in mAllocators {
			if let frame = allocator(name, ctxt) {
				return frame
			}
		}
		if name == "Frame" {
			return ALFrameCore(context: ctxt)
		} else {
			return nil
		}
	}
}
