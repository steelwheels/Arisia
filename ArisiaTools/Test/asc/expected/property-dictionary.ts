/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-dictionary-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("s", "d(n)") ;
root.definePropertyType("init0", "f(v,[o(root_FrameIF)])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["s","init0"]) ;
/* assign user declared properties */
root.s = {a:10, b:20};
root.init0 = function(self: FrameIF): void {
		console.print("keys = " + Object.keys(root.s) + "\n") ;
	};
/* execute initializer methods for frame root */
root.init0(root) ;
/* This value will be return value of evaluateScript() */
root ;
