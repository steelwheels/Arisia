interface root_FrameIF {
  a: number ;
  b: number ;
  l0: number ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
