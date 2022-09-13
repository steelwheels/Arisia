/*
 * Builtin.d.ts: Type declaration of ArisiaLibrary
 */

interface FrameCoreIF
{
	propertyNames: string[] ;

        set(name: string, value: any): boolean ;
	get(name: string): any | null ;

	addObserver(property: string, callback: () => void): void ;
}

export declare function _allocateFrameCore(classname: string): FrameCoreIF ;

