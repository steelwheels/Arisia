interface root_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  frameName: string ;
  label: labelIF ;
  ok_button: ok_buttonIF ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
interface root_label_LabelIF {
  addObserver(p0: string, p1: () => void): void ;
  frameName: string ;
  number: number ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  text: string ;
  value(p0: string): any ;
}
interface root_ok_button_ButtonIF {
  addObserver(p0: string, p1: () => void): void ;
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: <i>_<f>IF): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  title: string ;
  value(p0: string): any ;
}
