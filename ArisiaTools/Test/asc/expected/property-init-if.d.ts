interface root_FrameIF {
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  init0(p0 : FrameIF): void ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
