/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("sum", "n") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["sum"]) ;
/* assign user declared properties */
root.sum = function(a: number, b: number) {
		return a + b ;
	};
/* This value will be return value of evaluateScript() */
root ;
