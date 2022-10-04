/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-enum-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("axis", "e(Axis)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["axis"]) ;
/* assign user declared properties */
root.axis = Axis.horizontal;
/* This value will be return value of evaluateScript() */
root ;
