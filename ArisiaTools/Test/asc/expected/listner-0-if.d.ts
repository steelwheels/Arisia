interface root_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  f0: root_f0_FrameIF ;
  f1: root_f1_FrameIF ;
  f2: root_f2_FrameIF ;
  frameName: string ;
  init0(p0: rootFrameIF): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
interface root_f0_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  p0: number ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
interface root_f1_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  p1: number ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
interface root_f2_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  l0: number ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
