interface FrameIF {
  frameName : string ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
declare function _alloc_Frame(instname: string): FrameIF ;
