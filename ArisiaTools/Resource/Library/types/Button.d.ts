interface ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
declare function _alloc_Button(): ButtonIF ;
