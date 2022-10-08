interface root_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  propertyNames: string[] ;
  s: {[key: string]: number} ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
