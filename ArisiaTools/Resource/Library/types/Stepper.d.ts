interface StepperIF extends FrameCoreIF {
  frameName: string ;
  initValue: number ;
  maxValue: number ;
  minValue: number ;
  propertyNames: string[] ;
  stepValue: number ;
  updated(p0: StepperIF, p1: number): void ;
}
declare function _alloc_Stepper(): StepperIF ;
