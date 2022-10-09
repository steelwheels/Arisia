interface root_StackViewIF {
  addObserver(p0: string, p1: () => void): void ;
  alignment: Alignment ;
  axis: Axis ;
  button: root_button_ButtonViewIF ;
  definePropertyType(p0: string, p1: string): void ;
  distribution: Distribution ;
  frameName: string ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
interface root_button_ButtonViewIF {
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
