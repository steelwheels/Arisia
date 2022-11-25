interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  buttons: RadioButtonsIF ;
  distribution: Distribution ;
  frameName: string ;
  index_listner: number ;
  ok_button: ButtonIF ;
  propertyNames: string[] ;
}
interface root_buttons_RadioButtonsIF extends FrameCoreIF {
  columnNum: number ;
  currentIndex: number ;
  frameName: string ;
  labels: string[] ;
  propertyNames: string[] ;
  setEnable(p0: string, p1: boolean): void ;
}
interface root_ok_button_ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_ok_button_ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
