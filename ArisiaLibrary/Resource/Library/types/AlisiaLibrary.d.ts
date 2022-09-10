/*
 * Builtin.d.ts: Type declaration of ArisiaLibrary
 */

interface FrameCoreIF
{
	propertyNames: string[] ;

        set(name: string, value: any): boolean ;
	get(name: string): any | null ;
}

declare function _allocateFrameCore(classname: string): FrameCoreIF ;

/**
 * Transpiler.ts
 */
/// <reference path="KiwiLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
export declare function _definePropertyIF(frame: FrameCoreIF, usernames: string[]): void;
