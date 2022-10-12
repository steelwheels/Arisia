/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-array-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("s", "a(n)") ;
root.definePropertyType("init0", "f(v,[o(root_FrameIF)])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["s","init0"]) ;
/* assign user declared properties */
root.s = [1, 2, 3, 4];
root.init0 = function(self: FrameIF): void {
		console.print("*** property-array0,as\n") ;
		console.print("length = " + root.s.length + "\n") ;
	};
/* execute initializer methods for frame root */
root.init0(root) ;
/* This value will be return value of evaluateScript() */
root ;
