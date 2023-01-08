interface IconIF extends FrameIF {
  pressed(p0: FrameIF): void ;
  size: SymbolSize ;
  symbol: string ;
  title: string ;
}
declare function _alloc_Icon(): IconIF ;
