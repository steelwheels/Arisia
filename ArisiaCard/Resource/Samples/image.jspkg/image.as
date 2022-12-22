{
  img0: Image {
    name:   string     "card"
    scale:  number     1.0
  }
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
	    	leaveView(0) ;
        %}
  }
}

