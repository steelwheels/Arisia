/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/property-listner-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("a", "n") ;
root.definePropertyType("b", "n") ;
root.definePropertyType("l0", "n") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["a","b","l0"]) ;
/* assign user declared properties */
root.a = 1;
root.b = 2;
/* Define listner functions */
let _lfunc_root_l0 = function(self: FrameIF, a: number, b: number): number {
	let c = a + b ;
	console.print("update: c = " + c + "\n") ;
	return c ;
  } ;
/* add observers for listner function */
root.addObserver("a", function(){
  let self = root ;
  let a = root.a ;
  let b = root.b ;
  root.l0 = _lfunc_root_l0(self, a,b) ;
}) ;
root.addObserver("b", function(){
  let self = root ;
  let a = root.a ;
  let b = root.b ;
  root.l0 = _lfunc_root_l0(self, a,b) ;
}) ;
/* call listner methods to initialize it's property value for frame root */
root.l0 = _lfunc_root_l0(root, root.a, root.b) ;
/* This value will be return value of evaluateScript() */
root ;
