interface FrameIF {
  setValue(p0 : string, p1 : any): boolean ;
  frameName : string ;
  propertyNames : string[] ;
  value(p0 : string): any ;
}
declare function _alloc_Frame(): FrameIF ;
