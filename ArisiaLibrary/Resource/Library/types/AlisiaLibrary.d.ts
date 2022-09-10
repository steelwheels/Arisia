/*
 * Builtin.d.ts: Type declaration of ArisiaLibrary
 */

interface FrameCoreIF
{
        set(name: string, value: any): boolean ;
	get(name: string): any | null ;
}

declare function _allocateFrameCore(classname: string): FrameCoreIF? ;
/**
 * FrameCore.ts
 */
/// <reference path="KiwiLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
declare class Frame {
    core: FrameCoreIF;
    constructor();
    setNumber(name: string, value: number): void;
    number(name: string): number | null;
}
