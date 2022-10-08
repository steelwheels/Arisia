/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-event-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("pressed", "f(v,[o(FrameIF),b])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["pressed"]) ;
/* assign user declared properties */
root.pressed = function(self: FrameIF, isenable: boolean): void {
		console.log("pressed") ;
	};
/* This value will be return value of evaluateScript() */
root ;
