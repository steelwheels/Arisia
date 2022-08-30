"use strict";
/**
 * FrameCore.ts
 */
/// <reference path="types/KiwiLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
class Frame {
    constructor() {
        this.core = FrameCore();
    }
    setNumber(name, value) {
        this.core.set(name, value);
    }
    number(name) {
        return toNumber(this.core.get(name));
    }
}
