interface StackViewIF {
  frameName : string ;
  isEnabled : boolean ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  title : string ;
  value(p0 : string): any ;
}
declare function _alloc_StackView(instname: string): StackViewIF ;
