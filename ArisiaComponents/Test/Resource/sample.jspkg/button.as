{
  top: StackView {
    button_a: Button {
      title:  string "Back to First"
      pressed: event() %{
	console.log("leave view") ;
	leaveView(1234) ;
      %}
    }
  }
}

