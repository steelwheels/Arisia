interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  icon0: IconIF ;
  ok_button: ButtonIF ;
  propertyNames: string[] ;
}
interface root_icon0_IconIF extends FrameCoreIF {
  frameName: string ;
  image: string ;
  propertyNames: string[] ;
  size: IconSize ;
  symbol: number ;
  title: string ;
}
interface root_ok_button_ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_ok_button_ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}