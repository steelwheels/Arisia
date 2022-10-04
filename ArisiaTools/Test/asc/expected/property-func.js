/* allocate function for frame: Frame */
let root = _alloc_Frame()  ;
/* define type for all properties */
root.definePropertyType("sum", "n") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["sum"]) ;
/* assign user declared properties */
root.sum = function(a, b) {
		return a + b ;
	};
/* This value will be return value of evaluateScript() */
root ;
