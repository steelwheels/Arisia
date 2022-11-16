interface ImageIF extends FrameCoreIF {
  frameName: string ;
  name: string ;
  propertyNames: string[] ;
  scale: number ;
}
declare function _alloc_Image(): ImageIF ;
