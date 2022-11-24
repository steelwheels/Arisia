interface RadioButtonsIF extends FrameCoreIF {
  columnNum: number ;
  currentIndex: number ;
  frameName: string ;
  labels: string[] ;
  propertyNames: string[] ;
  setEnable(p0: string, p1: boolean): void ;
}
declare function _alloc_RadioButtons(): RadioButtonsIF ;
