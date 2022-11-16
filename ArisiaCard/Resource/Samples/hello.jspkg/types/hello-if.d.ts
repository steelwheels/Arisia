interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  label: LabelIF ;
  ok_button: ButtonIF ;
  propertyNames: string[] ;
}
interface root_label_LabelIF extends FrameCoreIF {
  frameName: string ;
  number: number ;
  propertyNames: string[] ;
  text: string ;
}
interface root_ok_button_ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_ok_button_ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
