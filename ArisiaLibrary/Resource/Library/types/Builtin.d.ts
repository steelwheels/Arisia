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

