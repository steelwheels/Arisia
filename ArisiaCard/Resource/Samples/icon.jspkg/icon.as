{
  icon0: Icon {
    image: string "card"
    size:  IconSize regular
  }
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
	    	leaveView(0) ;
        %}
  }
}

