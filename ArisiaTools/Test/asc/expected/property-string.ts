/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-string-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("s", "s") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["s"]) ;
/* assign user declared properties */
root.s = "hello, world";
/* This value will be return value of evaluateScript() */
root ;
