interface ButtonIF extends FrameIF {
  isEnabled: boolean ;
  pressed(p0: ButtonIF): void ;
  title: string ;
}
declare function _alloc_Button(): ButtonIF ;
