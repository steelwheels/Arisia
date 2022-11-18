interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  buttons: BoxIF ;
  distribution: Distribution ;
  frameName: string ;
  logo: ImageIF ;
  propertyNames: string[] ;
}
interface root_logo_ImageIF extends FrameCoreIF {
  frameName: string ;
  name: string ;
  propertyNames: string[] ;
  scale: number ;
}
interface root_buttons_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  cancel_button: ButtonIF ;
  distribution: Distribution ;
  frameName: string ;
  ok_button: ButtonIF ;
  propertyNames: string[] ;
}
interface root_buttons_ok_button_ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_buttons_ok_button_ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
interface root_buttons_cancel_button_ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_buttons_cancel_button_ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
