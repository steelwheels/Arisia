interface ButtonViewIF {
  setValue(p0 : string, p1 : any): boolean ;
  title : string ;
  frameName : string ;
  propertyNames : string[] ;
  value(p0 : string): any ;
  isEnabled : boolean ;
}
declare function _alloc_ButtonView(): ButtonViewIF ;
