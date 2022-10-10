{
  button: ButtonView {
    title: string "Hello, world !!"
    pressed: event() %{
      console.log("Pressed") ;
    %}
  }
}

