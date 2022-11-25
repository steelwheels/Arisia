{
  buttons: RadioButtons {
    labels: string[] ["label-0", "label-1", "label-2"]
    currentIndex: number 0
  }
  index_listner: number listner(idx: root.buttons.currentIndex) %{
    console.log("current_index: " + idx) ;
    return 0 ;
  %}
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
	    	leaveView(0) ;
        %}
  }
}

