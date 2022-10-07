/* allocate function for frame: Frame */
let root = _alloc_Frame()  ;
/* define type for all properties */
root.definePropertyType("init0", "f(v,[o(FrameIF)])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["init0"]) ;
/* assign user declared properties */
root.init0 = function(self) {
		console.print("Hello\n") ;
	};
/* execute initializer methods for frame root */
root.init0(root) ;
/* This value will be return value of evaluateScript() */
root ;
