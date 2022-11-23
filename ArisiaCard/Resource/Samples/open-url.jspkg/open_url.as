{
  ok_button: Button {
    title: string "OK"
    pressed: event() %{
      if(openURL("https://www.google.com/")){
        leaveView(0) ; // No error
      } else {
        leaveView(1) ; // Some error
      }
    %}
  }
}

