"use strict";
/* Panel.ts */
/// <reference path="types/ArisiaLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
function openPanel(title, type, exts) {
    let result = null;
    let sem = new Semaphore(0);
    let cbfunc = function (url) {
        result = url;
        sem.signal(); // Tell finish operation
    };
    _openPanel(title, type, exts, cbfunc);
    sem.wait(); // Wait finish operation
    return result;
}
function savePanel(title) {
    let result = null;
    let sem = new Semaphore(0);
    let cbfunc = function (url) {
        result = url;
        sem.signal(); // Tell finish operation
    };
    _savePanel(title, cbfunc);
    sem.wait(); // Wait finish operation
    return result;
}
