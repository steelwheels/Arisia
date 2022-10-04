interface StackViewIF {
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  isEnabled : boolean ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  title : string ;
  value(p0 : string): any ;
}
declare function _alloc_StackView(): StackViewIF ;
