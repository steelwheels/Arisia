/**
 * FrameCore.ts
 */

/// <reference path="types/KiwiLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>

class Frame
{
	core:	FrameCoreIF ;

	constructor(){
		this.core = FrameCore() ;
	}

	setNumber(name: string, value: number){
		this.core.set(name, value) ;
	}

	number(name: string): number | null {
		return toNumber(this.core.get(name)) ;
	}
}

