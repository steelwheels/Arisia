{
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
		console.log("pressed: OK") ;
	    	leaveView(1) ;
        %}
  }
}

