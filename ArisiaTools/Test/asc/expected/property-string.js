/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("s", "s") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["s"]) ;
/* assign user declared properties */
root.s = "hello, world";
