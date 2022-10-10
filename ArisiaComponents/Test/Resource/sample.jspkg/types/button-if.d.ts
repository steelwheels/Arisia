interface root_StackViewIF {
  addObserver(p0: string, p1: () => void): void ;
  alignment: Alignment ;
  axis: Axis ;
  definePropertyType(p0: string, p1: string): void ;
  distribution: Distribution ;
  frameName: string ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  top: root_top_StackViewIF ;
  value(p0: string): any ;
}
interface root_top_StackViewIF {
  addObserver(p0: string, p1: () => void): void ;
  alignment: Alignment ;
  axis: Axis ;
  button_a: root_top_button_a_ButtonViewIF ;
  definePropertyType(p0: string, p1: string): void ;
  distribution: Distribution ;
  frameName: string ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
interface root_top_button_a_ButtonViewIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_top_button_a_ButtonViewIF): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  title: string ;
  value(p0: string): any ;
}
