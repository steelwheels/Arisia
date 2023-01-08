interface StepperIF extends FrameIF {
  initValue: number ;
  maxValue: number ;
  minValue: number ;
  stepValue: number ;
  updated(p0: StepperIF, p1: number): void ;
}
declare function _alloc_Stepper(): StepperIF ;
