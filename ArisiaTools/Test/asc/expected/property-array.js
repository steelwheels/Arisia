/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("s", "an") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["s"]) ;
/* assign user declared properties */
root.s = [1, 2, 3, 4];
/* This value will be return value of evaluateScript() */
root ;
