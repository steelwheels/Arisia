interface BoxIF extends FrameIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
}
declare function _alloc_Box(): BoxIF ;
