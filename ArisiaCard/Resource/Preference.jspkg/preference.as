{
  logo: Image {
    name:  string  "arisia_icon"
  }
  buttons: Box {
    axis: Axis horizontal
    ok_button: Button {
      title: string "OK"
      pressed: event() %{
        leaveView(0) ;
      %}
    }
    cancel_button: Button {
      title: string "Cancel"
      pressed: event() %{
        leaveView(1) ;
      %}
    }
  }
}

