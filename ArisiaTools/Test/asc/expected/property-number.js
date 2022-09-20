/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("a", "n") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["a"]) ;
/* assign user declared properties */
root.a = 0;
