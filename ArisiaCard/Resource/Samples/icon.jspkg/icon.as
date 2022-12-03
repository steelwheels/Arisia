{
  icon0: Icon {
    symbol: string     "moon.stars"
    title:  string     "Hello"
    size:   SymbolSize regular
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

