/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/init-0-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("f0", "o(Frame)") ;
root.definePropertyType("init0", "f(v,[o(root_FrameIF)])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["f0","init0"]) ;
/* assign user declared properties */
root.init0 = function(self: FrameIF): void {
    console.print("root.init0()\n") ;
  };
{
  /* allocate function for frame: Frame */
  let f0 = _alloc_Frame() as root_f0_FrameIF ;
  /* define type for all properties */
  f0.definePropertyType("init0", "f(v,[o(root_f0_FrameIF)])") ;
  /* define getter/setter for all properties */
  _definePropertyIF(f0, ["init0"]) ;
  /* assign user declared properties */
  f0.init0 = function(self: FrameIF): void {
        console.print("root.f0.init0()\n") ;
      };
  root.f0 = f0 ;
}
/* Define listner functions */
/* execute initializer methods for frame f0 */
root.f0.init0(root.f0) ;
/* execute initializer methods for frame root */
root.init0(root) ;
/* This value will be return value of evaluateScript() */
root ;
