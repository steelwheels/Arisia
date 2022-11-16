interface BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  propertyNames: string[] ;
}
declare function _alloc_Box(): BoxIF ;
