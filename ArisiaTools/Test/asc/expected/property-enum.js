/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("axis", "eAxis") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["axis"]) ;
/* assign user declared properties */
root.axis = Axis.horizontal;
