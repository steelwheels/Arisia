/* allocate function for frame: Frame */
let root = _allocateFrameCore("Frame") ;
/* define type for all properties */
root.definePropertyType("f0", "iFrame") ;
root.definePropertyType("a0", "n") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["f0","a0"]) ;
/* assign user declared properties */
root.a0 = 2;
{
  /* allocate function for frame: Frame */
  let f0 = _allocateFrameCore("Frame") ;
  /* define type for all properties */
  f0.definePropertyType("a1", "n") ;
  /* define getter/setter for all properties */
  _definePropertyIF(f0, ["a1"]) ;
  /* assign user declared properties */
  f0.a1 = 1;
  root.f0 = f0 ;
}
