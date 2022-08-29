/*
 * Builtin.d.ts: Type declaration of ArisiaLibrary
 */

interface FrameCoreIF
{
        set(name: string, value: any): boolean ;
	get(name: string): any | null ;
}

declare function FrameCore(): FrameCoreIF ;
