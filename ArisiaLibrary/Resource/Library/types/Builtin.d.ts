/*
 * Builtin.d.ts: Type declaration of ArisiaLibrary
 */

interface FrameIF
{
	frameName: string ;
	propertyNames: string[] ;

        set(name: string, value: any): boolean ;
	get(name: string): any | null ;

	definePropertyType(property: string, typestr: string): void ;
	addObserver(property: string, callback: () => void): void ;
}

declare function _allocateFrameCore(classname: string): FrameIF ;

