/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-func-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("sum", "f(v,[n,n])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["sum"]) ;
/* assign user declared properties */
root.sum = function(a: number, b: number) {
		return a + b ;
	};
/* This value will be return value of evaluateScript() */
root ;
