{
  rad: RadioButtons {
    labels: string[] ["label-0", "label-1", "label-2"]
  }
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
	    	leaveView(0) ;
        %}
  }
}

