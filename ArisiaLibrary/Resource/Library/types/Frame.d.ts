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
