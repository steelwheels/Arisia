/*
 * window.ts
 */

/// <reference path="types/ArisiaLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>

function alert(type: AlertType, message: string, labels: string[]): number {
	let result = -1 ;
	let sem    = new Semaphore(0) ;
	let cbfunc = function(res: number) {
		result = res ;
		sem.signal() ;  // Tell finish operation
	} ;
	_alert(type, message, labels, cbfunc) ;
	sem.wait() ; // Wait finish operation
	return result ;
}

function enterView(path: string, arg: any): any {
	let sem    = new Semaphore(0) ;
	let result: any = 0 ;
	_enterView(path, arg, function(retval: any) {
		result = retval ;
		sem.signal() ;  // Tell finish operation
	})
	sem.wait() ; // Wait finish operation
	return result ;
}

