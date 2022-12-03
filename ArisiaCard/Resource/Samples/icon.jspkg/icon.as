{
  icon0: Icon {
    image: string "card"
    title: string "Hello"
    size:  SymbolSize small
    pressed: event() %{
      console.log("icon pressed") ;
    %}
  }
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
	    	leaveView(0) ;
        %}
  }
}

