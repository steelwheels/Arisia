interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  ok_button: ButtonIF ;
  propertyNames: string[] ;
  stepper: StepperIF ;
}
interface root_stepper_StepperIF extends FrameCoreIF {
  frameName: string ;
  initValue: number ;
  maxValue: number ;
  minValue: number ;
  propertyNames: string[] ;
  stepValue: number ;
  updated(p0: root_stepper_StepperIF, p1: number): void ;
}
interface root_ok_button_ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_ok_button_ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
