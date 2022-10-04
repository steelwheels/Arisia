interface StackViewIF {
  alignment : Alignment ;
  axis : Axis ;
  distribution : Distribution ;
  frameName : string ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
declare function _alloc_StackView(instname: string): StackViewIF ;
