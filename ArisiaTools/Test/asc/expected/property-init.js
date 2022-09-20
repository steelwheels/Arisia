/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("init0", "?") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["init0","_init0_ifunc"]) ;
/* assign user declared properties */
root._init0_ifunc = function(self) {
		console.print("Hello\n") ;
	};
/* execute initializer methods for frame root */
root.init0 = root._init0_ifunc(root) ;
