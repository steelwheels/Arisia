interface StackViewIF {
  alignment : Alignment ;
  axis : Axis ;
  definePropertyType(p0 : string, p1 : string): void ;
  distribution : Distribution ;
  frameName : string ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
declare function _alloc_StackView(): StackViewIF ;
