interface root_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  pressed(p0: root_FrameIF, p1: boolean): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
