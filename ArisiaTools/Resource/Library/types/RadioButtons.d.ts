interface RadioButtonsIF extends FrameIF {
  columnNum: number ;
  currentIndex: number ;
  labels: string[] ;
  setEnable(p0: string, p1: boolean): void ;
}
declare function _alloc_RadioButtons(): RadioButtonsIF ;
