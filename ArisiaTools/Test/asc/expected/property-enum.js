/* allocate function for frame: Frame */
let root = _alloc_Frame()  ;
/* define type for all properties */
root.definePropertyType("axis", "e(Axis)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["axis"]) ;
/* assign user declared properties */
root.axis = Axis.horizontal;
/* This value will be return value of evaluateScript() */
root ;
