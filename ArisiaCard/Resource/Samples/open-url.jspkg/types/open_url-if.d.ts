interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  ok_button: ButtonIF ;
  propertyNames: string[] ;
}
interface root_ok_button_ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_ok_button_ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
