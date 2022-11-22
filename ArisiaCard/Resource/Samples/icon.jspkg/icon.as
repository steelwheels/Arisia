{
  icon0: Icon {
    image: string "card"
    title: string "Hello"
    size:  IconSize small
  }
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
	    	leaveView(0) ;
        %}
  }
}

