/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-array-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("s", "a(n)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["s"]) ;
/* assign user declared properties */
root.s = [1, 2, 3, 4];
/* This value will be return value of evaluateScript() */
root ;
