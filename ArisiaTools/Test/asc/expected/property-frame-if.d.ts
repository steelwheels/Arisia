interface root_FrameIF {
  a0: number ;
  f0: root_f0_FrameIF ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
interface root_f0_FrameIF {
  a1: number ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
