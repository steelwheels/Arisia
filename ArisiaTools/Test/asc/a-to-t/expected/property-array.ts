/// <reference path="types/KiwiLibrary.d.ts" />
/// <reference path="types/ArisiaLibrary.d.ts" />
/// <reference path="types/ArisiaComponent.d.ts" />
/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("s", "a(n)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["s"]) ;
/* assign user declared properties */
root.s = [1, 2, 3, 4];
/* This value will be return value of evaluateScript() */
root ;
