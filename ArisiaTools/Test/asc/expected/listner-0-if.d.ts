interface root_FrameIF {
  definePropertyType(p0 : string, p1 : string): void ;
  f0 : Frame ;
  f1 : Frame ;
  f2 : Frame ;
  frameName : string ;
  init0(p0 : FrameIF): void ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
interface root_f0_FrameIF {
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  p0 : number ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
interface root_f1_FrameIF {
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  p1 : number ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
interface root_f2_FrameIF {
  definePropertyType(p0 : string, p1 : string): void ;
  frameName : string ;
  l0(p0 : FrameIF, p1 : number, p2 : number): void ;
  propertyNames : string[] ;
  setValue(p0 : string, p1 : any): boolean ;
  value(p0 : string): any ;
}
