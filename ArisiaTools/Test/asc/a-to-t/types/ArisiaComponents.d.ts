interface ButtonViewIF {
  setValue(p0 : string, p1 : any): boolean ;
  title : string ;
  frameName : string ;
  propertyNames : string[] ;
  value(p0 : string): any ;
  isEnabled : boolean ;
}
declare function _alloc_ButtonView(): ButtonViewIF ;
interface FrameIF {
  setValue(p0 : string, p1 : any): boolean ;
  frameName : string ;
  propertyNames : string[] ;
  value(p0 : string): any ;
}
declare function _alloc_Frame(): FrameIF ;
interface RootViewIF {
  setValue(p0 : string, p1 : any): boolean ;
  distribution : Distribution ;
  frameName : string ;
  axis : Axis ;
  propertyNames : string[] ;
  value(p0 : string): any ;
  alignment : Alignment ;
}
declare function _alloc_RootView(): RootViewIF ;
interface StackViewIF {
  setValue(p0 : string, p1 : any): boolean ;
  distribution : Distribution ;
  frameName : string ;
  axis : Axis ;
  propertyNames : string[] ;
  value(p0 : string): any ;
  alignment : Alignment ;
}
declare function _alloc_StackView(): StackViewIF ;
/// <reference path="KiwiLibrary.d.ts" />
/// <reference path="ArisiaLibrary.d.ts" />
/// <reference path="ButtonView.d.ts" />
/// <reference path="Frame.d.ts" />
/// <reference path="RootView.d.ts" />
/// <reference path="StackView.d.ts" />
declare function alloc_RootView(): RootViewIF | null;
