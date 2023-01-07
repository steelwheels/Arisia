{
  stepper: Stepper {
    minValue:  number -10.0
    maxValue:  number  10.0
    stepValue: number   1.0
    initValue: number   0.0
    updated: event(val: number) %{
      console.log("current value: " + val) ;
    %}
  }
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
	    	leaveView(0) ;
        %}
  }
}

