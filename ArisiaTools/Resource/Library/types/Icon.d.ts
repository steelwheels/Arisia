interface IconIF extends FrameCoreIF {
  frameName: string ;
  image: string ;
  pressed(p0: IconIF): void ;
  propertyNames: string[] ;
  size: IconSize ;
  symbol: number ;
  title: string ;
}
declare function _alloc_Icon(): IconIF ;
