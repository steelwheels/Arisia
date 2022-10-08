/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-init-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("init0", "f(v,[o(FrameIF)])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["init0"]) ;
/* assign user declared properties */
root.init0 = function(self: FrameIF): void {
		console.print("Hello\n") ;
	};
/* execute initializer methods for frame root */
root.init0(root) ;
/* This value will be return value of evaluateScript() */
root ;
