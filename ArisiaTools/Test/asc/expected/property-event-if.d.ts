interface root_FrameIF {
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  pressed : any ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
