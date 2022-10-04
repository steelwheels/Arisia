/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-boolean-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("a", "b") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["a"]) ;
/* assign user declared properties */
root.a = true;
/* This value will be return value of evaluateScript() */
root ;
