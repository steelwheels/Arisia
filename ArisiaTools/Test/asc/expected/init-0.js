/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("f0", "iFrame") ;
root.definePropertyType("init0", "?") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["f0","init0","_init0_ifunc"]) ;
/* assign user declared properties */
root._init0_ifunc = function(self) {
    console.print("root.init0()\n") ;
  };
{
  /* allocate function for frame: Frame */
  let f0 = _allocateFrameCore("Frame") ;
  /* define type for all properties */
  f0.definePropertyType("init0", "?") ;
  /* define getter/setter for all properties */
  _definePropertyIF(f0, ["init0","_init0_ifunc"]) ;
  /* assign user declared properties */
  f0._init0_ifunc = function(self) {
        console.print("root.f0.init0()\n") ;
      };
  root.f0 = f0 ;
}
/* execute initializer methods for frame f0 */
root.f0.init0 = root.f0._init0_ifunc(root.f0) ;
/* execute initializer methods for frame root */
root.init0 = root._init0_ifunc(root) ;
/* This value will be return value of evaluateScript() */
root ;
