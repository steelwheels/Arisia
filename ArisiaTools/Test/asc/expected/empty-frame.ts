/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/empty-frame-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define getter/setter for all properties */
_definePropertyIF(root, []) ;
/* This value will be return value of evaluateScript() */
root ;
