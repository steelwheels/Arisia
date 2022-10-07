interface root_FrameIF {
  a : number ;
  b : number ;
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  l0(p0 : FrameIF, p1 : number, p2 : number): void ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
