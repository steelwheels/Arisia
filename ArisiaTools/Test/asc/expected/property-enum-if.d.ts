interface root_FrameIF {
  axis : Axis ;
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
