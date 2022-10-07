/* allocate function for frame: Frame */
let root = _alloc_Frame()  ;
/* define type for all properties */
root.definePropertyType("pressed", "f(v,[o(FrameIF),b])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["pressed"]) ;
/* assign user declared properties */
root.pressed = function(self, isenable) {
		console.log("pressed") ;
	};
/* This value will be return value of evaluateScript() */
root ;
