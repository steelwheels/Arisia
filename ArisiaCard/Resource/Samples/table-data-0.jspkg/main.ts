/*
 * main.ts
 */

/// <reference path="./types/ArisiaComponents.d.ts"/>

function main(args: string[])
{
	console.log("Hello, world !!") ;
	let retval = enterView("table", null) ;
	console.log("Result = " + retval) ;
}

