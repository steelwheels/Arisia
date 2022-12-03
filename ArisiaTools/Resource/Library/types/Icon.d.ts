interface IconIF extends FrameCoreIF {
  frameName: string ;
  pressed(p0: IconIF): void ;
  propertyNames: string[] ;
  size: SymbolSize ;
  symbol: string ;
  title: string ;
}
declare function _alloc_Icon(): IconIF ;
