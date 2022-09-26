/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("s", "d(n)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["s"]) ;
/* assign user declared properties */
root.s = {a:10, b:20};
/* This value will be return value of evaluateScript() */
root ;
