/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-init-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("init0", "y") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["init0","_init0_ifunc"]) ;
/* assign user declared properties */
root._init0_ifunc = function(self: FrameIF) {
		console.print("Hello\n") ;
	};
/* execute initializer methods for frame root */
root.init0 = root._init0_ifunc(root) ;
/* This value will be return value of evaluateScript() */
root ;