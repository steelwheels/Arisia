interface root_FrameIF {
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  sum : number ;
  value(p0 : string): any ;
}