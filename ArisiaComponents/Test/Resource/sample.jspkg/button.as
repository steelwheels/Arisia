top: VBox {
    button_a: Button {
		title:  "Back to First"
        pressed: Event() %{
			console.log("leave view") ;
			leaveView(1234) ;
        %}
    }
}

