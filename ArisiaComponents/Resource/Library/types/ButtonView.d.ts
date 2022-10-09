interface ButtonViewIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: FrameIF): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  title: string ;
  value(p0: string): any ;
}
declare function _alloc_ButtonView(): ButtonViewIF ;
