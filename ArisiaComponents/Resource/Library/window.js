"use strict";
/*
 * window.ts
 */
/// <reference path="types/ArisiaLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>
function alert(type, message, labels) {
    let result = -1;
    let sem = new Semaphore(0);
    let cbfunc = function (res) {
        result = res;
        sem.signal(); // Tell finish operation
    };
    _alert(type, message, labels, cbfunc);
    sem.wait(); // Wait finish operation
    return result;
}
function enterView(path, arg) {
    let sem = new Semaphore(0);
    let result = 0;
    _enterView(path, arg, function (retval) {
        result = retval;
        sem.signal(); // Tell finish operation
    });
    sem.wait(); // Wait finish operation
    return result;
}
