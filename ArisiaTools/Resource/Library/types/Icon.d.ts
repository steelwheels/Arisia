interface IconIF extends FrameCoreIF {
  frameName: string ;
  image: string ;
  propertyNames: string[] ;
  size: IconSize ;
  symbol: number ;
  title: string ;
}
declare function _alloc_Icon(): IconIF ;
