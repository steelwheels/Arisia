/* allocate function for frame: Frame */
let root = _alloc_Frame()  ;
/* define type for all properties */
root.definePropertyType("f0", "o(Frame)") ;
root.definePropertyType("f1", "o(Frame)") ;
root.definePropertyType("f2", "o(Frame)") ;
root.definePropertyType("init0", "f(v,[o(FrameIF)])") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["f0","f1","f2","init0"]) ;
/* assign user declared properties */
root.init0 = function(self) {
	console.print("l0 = " + root.f2.l0 + "\n") ;
	root.f0.p0 = 3 ;
	root.f1.p1 = 4 ;
	console.print("l0 = " + root.f2.l0 + "\n") ;
  };
{
  /* allocate function for frame: Frame */
  let f0 = _alloc_Frame()  ;
  /* define type for all properties */
  f0.definePropertyType("p0", "n") ;
  /* define getter/setter for all properties */
  _definePropertyIF(f0, ["p0"]) ;
  /* assign user declared properties */
  f0.p0 = 1;
  root.f0 = f0 ;
}
{
  /* allocate function for frame: Frame */
  let f1 = _alloc_Frame()  ;
  /* define type for all properties */
  f1.definePropertyType("p1", "n") ;
  /* define getter/setter for all properties */
  _definePropertyIF(f1, ["p1"]) ;
  /* assign user declared properties */
  f1.p1 = 2;
  root.f1 = f1 ;
}
{
  /* allocate function for frame: Frame */
  let f2 = _alloc_Frame()  ;
  /* define type for all properties */
  f2.definePropertyType("l0", "f(v,[o(FrameIF),n,n])") ;
  /* define getter/setter for all properties */
  _definePropertyIF(f2, ["l0","_l0_lfunc"]) ;
  /* assign user declared properties */
  f2._l0_lfunc = function(self, p0, p1) {
        return p0 + p1 ;
      };
  root.f2 = f2 ;
}
/* add observers for listner function */
root.f0.addObserver("p0", function(){
  let self = root.f2 ;
  let p0 = root.f0.p0 ;
  let p1 = root.f1.p1 ;
  root.f2.l0 = root.f2._l0_lfunc(self, p0,p1) ;
}) ;
root.f1.addObserver("p1", function(){
  let self = root.f2 ;
  let p0 = root.f0.p0 ;
  let p1 = root.f1.p1 ;
  root.f2.l0 = root.f2._l0_lfunc(self, p0,p1) ;
}) ;
/* call listner methods to initialize it's property value for frame f2 */
root.f2.l0 = root.f2._l0_lfunc(root.f2, root.f0.p0, root.f1.p1) ;
/* execute initializer methods for frame root */
root.init0(root) ;
/* This value will be return value of evaluateScript() */
root ;
